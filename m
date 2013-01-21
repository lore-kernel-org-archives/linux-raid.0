From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Chances of silent errors?
Date: Mon, 21 Jan 2013 16:16:00 -0600
Message-ID: <CAAMCDee5T4iA6URWkBW5upr7Soj-BX6mefeEeHpXxKhzPWdDoA@mail.gmail.com>
References: <28222077.12.1358798287217.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28222077.12.1358798287217.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 21, 2013 at 1:58 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:
> Hi all
>
> Coming from the zfs world, I've heard a few talk about the chances of "silent errors", meaning the checksum on the drives match, but the data being bad because of matching checksum (aka collisions). Does anyone in here know the relative chance of something like that happening with the checksums of current harddisks? Is the 1:10^14 or 1:10^15 chances for a URE in regard to this, or is that when the drive reports an error, or those two combined?
>
> Vennlige hilsener / Best regards

I don't know about that result and am interested in the results.

On the silent corruption issues I have dealt with before both of them
came back to controller issues, in one case the raid/disk controller
had gone bad and would silently corrupt a block of data with a rate of
about 1 in 3-10GB of reads (never saw/confirmed corruption on writes),
in the other case because of the PCI-X bus speed being set too high (2
cards in use should have been at 100mhz was at 133mhz) it would
produce similar results on reads with blocks being corrupted about 1
block in 2-3 gb of reads.     Based on past data I am guessing the
silent corruption coming out of ram (non-ecc ram) and/or the
controller is likely at least an order of magnitude more likely an
issue on the disk.      The above referenced controllers were 2
completely different controllers by completely different companies.
I have never debugged corruption issues that was identified to be from
the disk itself, so I would suspect that the disks checksums are alot
more reliable that a lot of people believe and that the risk points
are at the controller -> pci -> cpu level were things are not so
carefully designed and checksummed.    Note that both of the
controllers were from (at the time) widely respected companies and
both were enterprise level cards (not home use cards--so cards that
cost > $US1k ).     And we added checksums at the software level to
give us end to end confirmation...as we had identified previous
corruption do to software/library issues...so in application is much
superior as it also catches software issues.
