From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Buffer I/O error on dev md5, logical block 7073536, async page
 read
Date: Mon, 31 Oct 2016 19:24:59 +0000
Message-ID: <58179A8B.6010507@youngman.org.uk>
References: <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de> <20161030164342.GC28648@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161030164342.GC28648@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/10/16 16:43, Marc MERLIN wrote:
> And here isn't one good drive between the 2, the bad blocks are identical on
> both drives and must have happened at the same time due to those cable
> induced IO errors I mentionned.
> Too bad that mdadm doesn't seem to account for the fact that it could be
> wrong when marking blocks as bad and does not seem to give a way to recover
> from this easily....
> I'll do more reading, thanks.

Reading the list, I've picked up that somehow badblocks seem to get
propagated from one drive to another. So if one drive gets a badblock,
that seems to get marked as bad on other drives too :-(

Oh - and as for badblocks being obsolete, isn't there a load of work
being done on it at the moment? For hardware raid I believe, which
presumably does not handle badblocks the way Phil thinks all modern
drives do? (Not surprising - hardware raid is regularly slated for being
buggy and not a good idea, this is probably more of the same...)

Cheers,
Wol
