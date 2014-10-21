#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 48;

use Games::Solitaire::Verify::Card;

{
    my $card = Games::Solitaire::Verify::Card->new(
        {
            string => "AH",
        },
    );

    # TEST
    is ($card->rank(), 1, "Rank of AH is 1");

    # TEST
    is ($card->suit(), "H", "Suit of AH is Hearts");

    # TEST
    is ($card->color(), "red", "Color of AH is red");
}

{
    my $card = Games::Solitaire::Verify::Card->new(
        {
            string => "QC",
        },
    );

    # TEST
    is ($card->rank(), 12, "Rank of QC is 12");

    # TEST
    is ($card->suit(), "C", "Suit of QC is Clubs");

    # TEST
    is ($card->color(), "black", "Color of QC is black");
}

{
    my $card = Games::Solitaire::Verify::Card->new(
        {
            string => "KS",
        },
    );

    # TEST
    is ($card->rank(), 13, "Rank of KS is 13");

    # TEST
    is ($card->suit(), "S", "Suit of KS is Spades");

    # TEST
    is ($card->color(), "black", "Color of KS is black");
}

{
    my $card = Games::Solitaire::Verify::Card->new(
        {
            string => "5H",
        },
    );

    # TEST
    is ($card->rank(), 5, "Rank of 5H is 5");

    # TEST
    is ($card->suit(), "H", "Suit of 5H is Hearts");

    # TEST
    is ($card->color(), "red", "Color of 5H is red");
}

{
    my $card = Games::Solitaire::Verify::Card->new(
        {
            string => "<5H>",
        },
    );

    # TEST
    is ($card->rank(), 5, "Rank of 5H is 5");

    # TEST
    is ($card->suit(), "H", "Suit of 5H is Hearts");

    # TEST
    is ($card->color(), "red", "Color of 5H is red");

    # TEST
    ok ($card->is_flipped(), "Card is flipped.");

    # TEST
    is ($card->to_string(), '<5H>', "Stringification of a flipped card.");

    $card->set_flipped(0);

    # TEST
    is ($card->to_string(), '5H',
        "Stringification of a no longer flipped card."
    );
}

{
    my $card = Games::Solitaire::Verify::Card->new(
        {
            string => "5H",
        },
    );

    # TEST
    is ($card->rank(), 5, "Rank of 5H is 5");

    # TEST
    is ($card->suit(), "H", "Suit of 5H is Hearts");

    # TEST
    is ($card->color(), "red", "Color of 5H is red");

    my $copy = $card->clone();

    $card->rank(1);
    $card->suit("C");

    # TEST
    is ($copy->rank(), 5, "Rank of copy is 5");

    # TEST
    is ($copy->suit(), "H", "Suit of copy is Hearts");

    # TEST
    is ($copy->color(), "red", "Color of copy is red");

}

{
    my $card;
    eval {
        $card = Games::Solitaire::Verify::Card->new(
            {
                string => "Foobar",
            }
        );
    };

    my $e = Exception::Class->caught();

    # TEST
    isa_ok ($e, "Games::Solitaire::Verify::Exception::Parse::Card",
        "Caught a card parsing exception"
    );
}

{
    my $card;
    eval {
        $card = Games::Solitaire::Verify::Card->new(
            {
                string => "ZH",
            }
        );
    };

    my $e = Exception::Class->caught();

    # TEST
    isa_ok ($e, "Games::Solitaire::Verify::Exception::Parse::Card::UnknownRank",
        "unknown rank"
    );
}

{
    my $card;
    eval {
        $card = Games::Solitaire::Verify::Card->new(
            {
                string => "A*",
            }
        );
    };

    my $e = Exception::Class->caught();

    # TEST
    isa_ok ($e, "Games::Solitaire::Verify::Exception::Parse::Card::UnknownSuit",
        "unknown suit"
    );
}

{
    # TEST:$num_cards=13
    my @cards = (qw(
        AS
        2H
        3D
        4H
        5H
        6S
        7C
        8C
        9H
        TS
        JS
        QH
        KS
        ));

    foreach my $string (@cards)
    {
        my $card = Games::Solitaire::Verify::Card->new(
            {
                string => $string,
            },
        );

        # TEST*$num_cards
        is ($card->to_string(), $string, "Stringification of '$string'");
    }
}

{
    my $card = Games::Solitaire::Verify::Card->new(
        {
            string => "QC",
            id => 4,
        },
    );

    # TEST
    is ($card->id(), 4, "ID of the card is 4");

    my $copy = $card->clone();

    # TEST
    ok ($copy, "QC with ID was cloned.");

    # TEST
    is ($copy->id(), 4, "ID of the copy is the same.");
}

{
    my $card = Games::Solitaire::Verify::Card->new(
        {
            string => "5H",
            id => 79,
            data => { key => 'Foo', },
        },
    );

    # TEST
    is ($card->id(), 79, "ID of card with id and data is OK.");

    # TEST
    is_deeply(
        $card->data(),
        { key => 'Foo', },
        'Data is OK.',
    );

    my $copy = $card->clone();

    # TEST
    ok ($copy, '5H with id 79 was cloned.');

    # TEST
    is ($copy->id(), 79, "ID of the copy is the same.");

    # TEST
    is_deeply(
        $copy->data(),
        { key => 'Foo', },
        'Copy Data is OK.',
    );
}
