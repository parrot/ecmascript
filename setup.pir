#!/usr/bin/env parrot
# Copyright (C) 2009, Parrot Foundation.
# $Id$

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    .const 'Sub' testclean = 'testclean'
    register_step_after('test', testclean)
    register_step_after('clean', testclean)

    $P0 = new 'Hash'
    $P0['name'] = 'ecmascript'
    $P0['abstract'] = 'aka JavaScript'
    $P0['description'] = 'aka JavaScript'
    $P0['license_type'] = 'Artistic License 2.0'
    $P0['license_uri'] = 'http://www.perlfoundation.org/artistic_license_2_0'
    $P0['copyright_holder'] = 'Parrot Foundation'
    $P0['checkout_uri'] = 'https://svn.parrot.org/languages/ecmascript/trunk'
    $P0['browser_uri'] = 'https://trac.parrot.org/languages/browser/ecmascript'
    $P0['project_uri'] = 'https://trac.parrot.org/parrot/wiki/Languages'

    # build
    $P1 = new 'Hash'
    $P1['src/gen_grammar.pir'] = 'src/parser/grammar.pg'
    $P0['pir_pge'] = $P1

    $P2 = new 'Hash'
    $P2['src/gen_actions.pir'] = 'src/parser/actions.pm'
    $P0['pir_nqp'] = $P2

    $P3 = new 'Hash'
    $P4 = split "\n", <<'SOURCES'
js.pir
src/gen_grammar.pir
src/gen_actions.pir
src/builtin/builtins.pir
src/classes/Object.pir
src/classes/Array.pir
src/classes/Boolean.pir
src/classes/Null.pir
SOURCES
    $S0 = pop $P4
    $P3['js.pbc'] = $P4
    $P0['pbc_pir'] = $P3

    $P5 = new 'Hash'
    $P5['parrot-js'] = 'js.pbc'
    $P0['installable_pbc'] = $P5

    # test
    $P0['harness_files'] = ''

    # dist
    $P9 = glob('lib/Parrot/Test/*.pm lib/Parrot/Test/JS/*.pm t/*.t t/js_pt/*.t t/sanity_pt/*.t')
    $P0['manifest_includes'] = $P9

    .tailcall setup(args :flat, $P0 :flat :named)
.end

.sub 'testclean' :anon
    .param pmc kv :slurpy :named
    .local string cmd
    cmd = 'perl -MExtUtils::Command -e rm_f t/js_pt/*.js t/js_pt/*.out t/sanity_pt/*.js t/sanity_pt/*.out'
    system(cmd)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
