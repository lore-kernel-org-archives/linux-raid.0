From: Jon Lewis <jlewis@lewis.org>
Subject: Re: Joys of spare disks!
Date: Mon, 28 Feb 2005 10:04:13 -0500 (EST)
Message-ID: <Pine.LNX.4.58.0502281000290.32355@web1.mmaero.com>
References: <cvv9ai$svg$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <cvv9ai$svg$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 28 Feb 2005, Robin Bowes wrote:

> Hi,
>
> I run a RAID5 array built from six 250GB Maxtor Maxline II SATA disks.
> After having several problems with Maxtor disks I decided to use a spare
> disk, i.e. 5+1 spare.

Are you aware Maxtor had a bad batch(es?) of large SATA drives?  We have a
few machines with 6 Maxtor 6Y200M0 drives and got a couple bad drives.
They have a utility program (powermax) you can run that will tell you if
any of your drives are bad.  The bad ones will appear to work...but not
entirely reliably.  i.e. the system I installed that had 1 bad drive could
not resync the RAID5.  It would always either crash or lock up during the
resync.

----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
