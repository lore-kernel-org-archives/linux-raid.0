From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: max number of devices in raid6 array
Date: Thu, 13 Aug 2009 22:40:00 -0500
Message-ID: <20090814033956573.OVIM16701@cdptpa-omta01.mail.rr.com>
References: <3638F6C82C4E4E2480F54B80F38BE410@m5>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3638F6C82C4E4E2480F54B80F38BE410@m5>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I don't believe a block read error is considered in the MTBF.  A current
> 2TB
> disk has a "<1 in 10^15" "Non-recoverable read errors per bits read".
> That
> is about 1 error per 114 TB read (10^15/8/1024/1024/1024/1024).  So, you
> should get 1 failure per about 114 TB read.  If you had 57 2TB disks + 1
> parity, your chance of a read error should be 1 during a recovery.  If you

	It doesn't work that way.  Just because there is a 1 in 2 chance of
getting heads in a coin flip does not mean you must get a heads if you flip
the coin twice.  The odds of getting at least 1 heads with two coin tosses
is 75%.  The odds of rolling a 1 with six throws of a single die are 66.5%
If one takes a card from a deck, replaces the card in the desk, shuffles,
and pulls another card from the deck, repeating 52 times, the odds of
drawing the Ace of Spades once is 63.6%  Only if one removes the card from
the deck completely each time do the odds rise to 1.

	In this case it means on average there may be 1 error in 1E15 reads,
provided one reads many hundreds of TB.  To calculate the odds of single
error for precisely 1E15 bits read, take 1 - 1E-15 and raise it to the power
of the total number of bits read.  This equals the odds of NOT getting any
error.  Subtract that number from 1, and you have the odds of getting an
error.  If we read 1E15 bits, then the odds of getting a single error are

1 - .999999999999999^1E15

	It's about 63%.


