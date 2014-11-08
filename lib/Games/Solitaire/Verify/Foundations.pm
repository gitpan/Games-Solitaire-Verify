package Games::Solitaire::Verify::Foundations;

use warnings;
use strict;


our $VERSION = '0.1400';

use parent 'Games::Solitaire::Verify::Base';

use Games::Solitaire::Verify::Exception;
use Games::Solitaire::Verify::Card;

use List::Util qw(first);

__PACKAGE__->mk_acc_ref([qw(
    _num_decks
    _founds
    )]);


sub _input_from_string
{
    my $self = shift;
    my $str = shift;

    my $rank_re = '[0A1-9TJQK]';

    if($str !~ m{\AFoundations: H-($rank_re) C-($rank_re) D-($rank_re) S-($rank_re) *\z}ms)
    {
        Games::Solitaire::Verify::Exception::Parse::State::Foundations->throw(
            error => "Wrong Foundations",
        );
    }
    {
        my @founds_strings = ($1, $2, $3, $4);

        foreach my $suit (@{$self->_get_suits_seq()})
        {
            $self->assign($suit, 0,
                Games::Solitaire::Verify::Card->calc_rank_with_0(
                        shift(@founds_strings)
                    )
                );
        }
    }
}

sub _init
{
    my ($self, $args) = @_;

    if (! exists($args->{num_decks}))
    {
        die "No number of decks were specified";
    }

    $self->_num_decks($args->{num_decks});

    $self->_founds(
        +{
            map
            { $_ => [(0) x $self->_num_decks()], }
            @{$self->_get_suits_seq()}
        }
    );

    if (exists($args->{string}))
    {
        $self->_input_from_string($args->{string});
    }

    return;
}

sub _get_suits_seq
{
    my $class = shift;

    return Games::Solitaire::Verify::Card->get_suits_seq();
}


sub value
{
    my ($self, $suit, $idx) = @_;

    return $self->_founds()->{$suit}->[$idx];
}


sub assign
{
    my ($self, $suit, $idx, $rank) = @_;

    $self->_founds()->{$suit}->[$idx] = $rank;

    return;
}


sub increment
{
    my ($self, $suit, $idx) = @_;

    $self->_founds()->{$suit}->[$idx]++;

    return;
}


sub _foundations_strings
{
    my $self = shift;

    return [
        map {
            sprintf(qq{ %s-%s},
                $_,
                Games::Solitaire::Verify::Card->rank_to_string(
                    $self->value($_, 0)
                ),
            )
        }
        (@{$self->_get_suits_seq()})
    ];
}

sub to_string
{
    my $self = shift;

    return   "Foundations:"
           . join("", @{$self->_foundations_strings()})
           . " " # We need the trailing space for compatibility with
                 # Freecell Solver.
           ;
}



sub clone
{
    my $self = shift;

    my $copy =
        __PACKAGE__->new(
            {
                num_decks => $self->_num_decks(),
            }
        );

    foreach my $suit (@{$self->_get_suits_seq()})
    {
        foreach my $deck_idx (0 .. ($self->_num_decks()-1))
        {
            $copy->assign(
                $suit, $deck_idx,
                $self->value($suit, $deck_idx),
            );
        }
    }

    return $copy;
}

1; # End of Games::Solitaire::Verify::Move

__END__

=pod

=encoding UTF-8

=head1 NAME

Games::Solitaire::Verify::Foundations - a class for representing the
foundations (or home-cells) in a Solitaire game.

=head1 VERSION

version 0.1400

=head1 SYNOPSIS

    use Games::Solitaire::Verify::Foundations;

    # For internal use.

=head1 METHODS

=head2 $self->value($suit, $index)

Returns the card in the foundation $suit with the index $index .

=head2 $self->assign($suit, $index, $rank)

Sets the value of the foundation with the suit $suit and the
index $index to $rank .

=head2 $self->increment($suit, $index)

Increments the value of the foundation with the suit $suit and the
index $index to $rank .

=head2 $self->to_string()

Stringifies the freecells into the Freecell Solver solution display notation.

=head2 $board->clone()

Returns a clone of the freecells, with all of their cards duplicated.

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
