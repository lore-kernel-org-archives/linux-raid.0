From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Wed, 21 Sep 2005 00:15:29 +0000
Message-ID: <62b0912f050920171550edcab1@mail.gmail.com>
References: <20050916125754.11044.patches@notabene>
	 <1050916030157.11071@suse.de>
Reply-To: molle.bestefich@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1050916030157.11071@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> TESTERS WANTED!!  SEE BELOW...
> 
> This patch changes the behaviour of raid5 when it gets a read error.
> Instead of just failing the device, it tried to find out what should
> have been there, and writes it over the bad block.

Jip-hee!  Beautiful!!
Neil, a big, warm and fuzzy Thank You for all the hard work you put into MD!

I do not have a test system, so I've tried to apply the patch to a
smallish (6 disk ata) live system instead.  (Am I sane?)

Some of the disks have probably developed a couple of bad blocks here
and there by now.  I imagine doing a 'dd' from the MD device will read
at least 83% of all sectors (?), so there's a fair chance I'll hit
something if it's there.

Applying the patch doesn't quite work for me:
==============================================
linux-2.6.13.2 # patch --dry-run -p0 < md-rewrite-bad-blocks.patch
patching file ./drivers/md/raid5.c
Hunk #1 succeeded at 339 (offset -10 lines).
Hunk #3 succeeded at 963 (offset -20 lines).
Hunk #4 FAILED at 983.
Hunk #5 succeeded at 1044 (offset -2 lines).
Hunk #6 succeeded at 1274 (offset -32 lines).
1 out of 6 hunks FAILED -- saving rejects to file ./drivers/md/raid5.c.rej
patching file ./include/linux/raid/raid5.h
Hunk #1 succeeded at 153 (offset -1 lines).
==============================================

Hunk #4 succeds if given a fuzz of 3...
Is it safe to use the patch with 2.6.13.2?
