load("@bazel_lib//lib:transitions.bzl", "platform_transition_binary")
load("@rules_shell//shell:sh_test.bzl", "sh_test")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

_SH = """
#!/usr/bin/env bash

exec sim65 {prg}
"""

def _sim65_test_impl(name, srcs, deps, **kwargs):
    tests = []

    for test_file in srcs:
        test_basename = test_file.name.removesuffix(".c")

        native.genrule(
            name = "%s_%s_obj" % (name, test_basename),
            srcs = [test_file],
            outs = ["%s.o" % test_basename],
            cmd = "OUT=$(RULEDIR) CFLAGS='-O -t sim6502 -I./{pkg} -DTESTING' $(execpath //tools:cc65) $(SRCS)".format(pkg = native.package_name()),
            output_to_bindir = True,
            tags = ["local"],
            tools = ["//tools:cc65"],
            target_compatible_with = [
                "//platforms/os:sim65",
                "//platforms/cpu:6502",
            ],
        )

        native.genrule(
            name = "%s_%s_prg" % (name, test_basename),
            srcs = [":%s_%s_obj" % (name, test_basename)] + deps,
            outs = ["%s_%s.prg" % (name, test_basename)],
            cmd = "cl65 -t sim6502 -o $@ $(SRCS)",
            executable = True,
            tags = ["local"],
            target_compatible_with = [
                "//platforms/os:sim65",
                "//platforms/cpu:6502",
            ],
        )

        platform_transition_binary(
            name = "%s_%s_sim6502" % (name, test_basename),
            binary = ":%s_%s_prg" % (name, test_basename),
            target_platform = "//platforms:sim6502",
            tags = ["manual"],
        )

        write_file(
            name = "%s_%s_sh" % (name, test_basename),
            out = "%s_%s.sh" % (name, test_basename),
            is_executable = True,
            content = [_SH.format(prg = native.package_name() + "/%s_%s_sim6502/%s_%s.prg"%(name, test_basename,name, test_basename))]
        )

        sh_test(
            name = "%s_%s" % (name, test_basename),
            srcs = [":%s_%s_sh" % (name, test_basename)],
            data = ["%s_%s_sim6502" % (name, test_basename)],
            size = "small",
            tags = ["local"],
        )

        tests.append(":%s_%s" % (name, test_basename))

    native.test_suite(
        name = name,
        tests = tests,
    )

sim65_test = macro(
    implementation = _sim65_test_impl,
    attrs = dict(
        srcs = attr.label_list(allow_files = True, configurable = False),
        deps = attr.label_list(),
    ),
)
