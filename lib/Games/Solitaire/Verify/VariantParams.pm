package Games::Solitaire::Verify::VariantParams;

use warnings;
use strict;


our $VERSION = '0.1400';

use parent 'Games::Solitaire::Verify::Base';

use Games::Solitaire::Verify::Exception;

__PACKAGE__->mk_acc_ref([qw(
    empty_stacks_filled_by
    num_columns
    num_decks
    num_freecells
    rules
    seq_build_by
    sequence_move
    )]);


my %seqs_build_by = (map { $_ => 1 } (qw(alt_color suit rank)));
my %empty_stacks_filled_by_map = (map { $_ => 1 } (qw(kings any none)));
my %seq_moves = (map { $_ => 1 } (qw(limited unlimited)));
my %rules_collection = (map { $_ => 1 } (qw(freecell simple_simon)));

sub _init
{
    my ($self, $args) = @_;

    # Set the variant
    #

    {
        my $seq_build_by = $args->{seq_build_by};

        if (!exists($seqs_build_by{$seq_build_by}))
        {
            Games::Solitaire::Verify::Exception::VariantParams::Param::SeqBuildBy->throw(
                    error => "Unrecognised seq_build_by",
                    value => $seq_build_by,
            );
        }
        $self->seq_build_by($seq_build_by);
    }

    {
        my $esf = $args->{empty_stacks_filled_by};

        if (!exists($empty_stacks_filled_by_map{$esf}))
        {
            Games::Solitaire::Verify::Exception::VariantParams::Param::EmptyStacksFill->throw(
                    error => "Unrecognised empty_stacks_filled_by",
                    value => $esf,
            );
        }

        $self->empty_stacks_filled_by($esf);
    }

    {
        my $num_decks = $args->{num_decks};

        if (! (($num_decks == 1) || ($num_decks == 2)) )
        {
            Games::Solitaire::Verify::Exception::VariantParams::Param::NumDecks->throw(
                    error => "Wrong Number of Decks",
                    value => $num_decks,
            );
        }
        $self->num_decks($num_decks);
    }

    {
        my $num_columns = $args->{num_columns};

        if (($num_columns =~ /\D/)
                ||
            ($num_columns == 0))
        {
            Games::Solitaire::Verify::Exception::VariantParams::Param::Stacks->throw(
                    error => "num_columns is not a number",
                    value => $num_columns,
            );
        }
        $self->num_columns($num_columns)
    }

    {
        my $num_freecells = $args->{num_freecells};

        if ($num_freecells =~ /\D/)
        {
            Games::Solitaire::Verify::Exception::VariantParams::Param::Freecells->throw(
                    error => "num_freecells is not a number",
                    value => $num_freecells,
            );
        }
        $self->num_freecells($num_freecells);
    }

    {
        my $seq_move = $args->{sequence_move};

        if (!exists($seq_moves{$seq_move}))
        {
            Games::Solitaire::Verify::Exception::VariantParams::Param::SeqMove->throw(
                    error => "Unrecognised sequence_move",
                    value => $seq_move,
            );
        }

        $self->sequence_move($seq_move);
    }

    {
        my $rules = $args->{rules} || "freecell";

        if (!exists($rules_collection{$rules}))
        {
            Games::Solitaire::Verify::Exception::VariantParams::Param::Rules->throw(
                    error => "Unrecognised rules",
                    value => $rules,
            );
        }
        $self->rules($rules);
    }

    return 0;
}



sub clone
{
    my $self = shift;

    return __PACKAGE__->new(
        {
            empty_stacks_filled_by => $self->empty_stacks_filled_by(),
            num_columns => $self->num_columns(),
            num_decks => $self->num_decks(),
            num_freecells => $self->num_freecells(),
            rules => $self->rules(),
            seq_build_by => $self->seq_build_by(),
            sequence_move => $self->sequence_move(),
        }
    );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Games::Solitaire::Verify::VariantParams - a class for holding
the parameters of the variant.

=head1 VERSION

version 0.1400

=head1 SYNOPSIS

    use Games::Solitaire::Verify::VariantParams;

    my $freecell_params =
        Games::Solitaire::Verify::VariantParams->new(
            {
                seq_build_by => "alt_color",
            },
        );

=head1 METHODS

=head2 $variant_params->empty_stacks_filled_by()

What empty stacks can be filled by:

=over 4

=item * any

=item * none

=item * kings

=back

=head2 $variant_params->num_columns()

The number of columns the variant has.

=head2 $variant_params->num_decks()

The numbe of decks the variant has.

=head2 $variant_params->num_freecells()

The number of freecells the variant has.

=head2 $variant_params->rules()

The rules by which the variant obides:

=over 4

=item * freecell

=item * simple_simon

=back

=head2 $variant_params->seq_build_by()

Returns the sequence build by:

=over 4

=item * alt_color

=item * suit

=back

=head2 $variant_params->sequence_move()

=over 4

=item * limited

=item * unlimited

=back

=head2 $self->clone()

Returns a clone.

=head1 AUTHOR

Shlomi Fish <shlomif@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-Solitaire-Verify or by email
to bug-games-solitaire-verify@rt.cpan.org.

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc Games::Solitaire::Verify

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

MetaCPAN

A modern, open-source CPAN search engine, useful to view POD in HTML format.

L<http://metacpan.org/release/Games-Solitaire-Verify>

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/Games-Solitaire-Verify>

=item *

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-Solitaire-Verify>

=item *

AnnoCPAN

The AnnoCPAN is a website that allows community annotations of Perl module documentation.

L<http://annocpan.org/dist/Games-Solitaire-Verify>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/Games-Solitaire-Verify>

=item *

CPAN Forum

The CPAN Forum is a web forum for discussing Perl modules.

L<http://cpanforum.com/dist/Games-Solitaire-Verify>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.perl.org/dist/overview/Games-Solitaire-Verify>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/G/Games-Solitaire-Verify>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=Games-Solitaire-Verify>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=Games::Solitaire::Verify>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-games-solitaire-verify at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-Solitaire-Verify>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<http://bitbucket.org/shlomif/fc-solve>

  git clone http://bitbucket.org/shlomif/fc-solve

=cut
