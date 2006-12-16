From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID1 root and swap and initrd
Date: Sun, 17 Dec 2006 00:50:59 +0300
Message-ID: <45846A43.8070207@tls.msk.ru>
References: <20061215175630.GA11400@aym.net2.nerim.net> <Pine.LNX.4.64.0612151909210.27298@lion.drogon.net> <20061216210517.GB11400@aym.net2.nerim.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061216210517.GB11400@aym.net2.nerim.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Majorel <aym-xunil@teaser.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Majorel wrote:
[]
> Thanks Jurriaan and Gordon. I think I may still be f*cked,
> however. The Lilo doc says you can't use raid-extra-boot=mbr-only
> if boot= does not point to a raid device. Which it doesn't because
> in my setup, boot=/dev/sda.
> 
> Using boot=/dev/md5 would solve the raid-extra-boot issue but the
> components of /dev/md5 are not primary partitions (/dev/sda5,
> /dev/sdb5) so I don't think that would work.

So just move it to sda1 (or sda2, sda3) from sda5, ensure you've
two identical drives (or at least your boot partitions are layed
up identically), and use boot=/dev/md1 (or md2, md3).  Do NOT
use raid-extra-boot (set it to "none"), but set up standard mbr
code into boot sector of both drives (in debian, it's 'mbr' package;
lilo can be used for that too - once for each drive), and mark your
boot partition on both drives as active.

This is the most clean setup to boot off raid.  You'll have two
drives, both will be bootable, and both will be updated when
you'll run lilo.

Another bonus - if you'll ever install a foreign OS on this system,
which tends to update boot code, all your stuff will still be intact -
the only thing you'll need to do to restore linux boot is to reset
'active' flags for your partitions (and no, winnt disk manager does
not allow you to do so - no ability to set non-dos (non-windows)
partition active).

> I *could* run lilo once for each disk after tweaking boot= in
> lilo.conf, or just supply a different -M option but I'm not sure.
> The Lilo doc is not terribly enlightening. Not for me, anyway. :-)

No, don't do that. Even if you can automate it.  It's error-prone
to say the best, and it will bite you at an unexpected moment.

>> A nice little tip I learned from someone else on the list is to
>> have your md devices named after the partition numbers. So:

That'd be me... ;)

/mjt
