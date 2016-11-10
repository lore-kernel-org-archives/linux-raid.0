From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Help in recovering a RAID5 volume
Date: Thu, 10 Nov 2016 17:06:32 +0000
Message-ID: <5824A918.3030300@youngman.org.uk>
References: <CA+GmhESH-2hDJrOjvNzVBsgCP65BnUE2AbfOZ1Bbrp02jyBNUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+GmhESH-2hDJrOjvNzVBsgCP65BnUE2AbfOZ1Bbrp02jyBNUQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Felipe Kich <fkich1977@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/11/16 15:41, Felipe Kich wrote:
> So, with that info, I could verify some things that are frequently
> mentioned on the posts:
> - SCT Error Recovery Control is disabled for both Read and Write operations;
> - Events counter in the devices are the same, except for one disk, but
> the difference is small (<50);
> - Magic Numbers and Checksums are all correct;
> 
> Hope someone can give some advice as how to proceed next.
> 
Okay. It says the drives are failing, so the first thing is to go out
and get four new drives :-( Ouch!

Preferably WD Reds or Seagate NAS (Toshibas seem to support ERC too, I'm
not sure...)

DON'T TOUCH A 3TB BARRACUDA. Barracudas aren't a good idea but the 3TB
disk is apparently an especially bad choice.

Do you want to upgrade your array size? Or do you want to go Raid-6?
Four 2TB drives will give you a 4TB Raid-6 array. And look at getting 3-
or 4TB drives, they're good value for money. You might decide it's not
worth it.

Copy and replace all the failing drives with ddrescue. Hopefully you'll
get a perfect copy. Don't worry that the old drive is smaller than the
new one if you get 2TB or larger drives.

Assuming everything copies fine, find the three drives that are copies
of sda, sdb, sdd (ie the ones with the highest event counts), and
assemble with --force. You should now have a new array working fine. Do
a fsck to make sure everything's okay - you'll probably lose a file or
two :-(

Add in the fourth disk - it'll trigger a rebuild, but that's normal.

Now if your new disks are bigger than the old ones, you can expand the
array to use the space. You can either create a new partition in the
empty drive space for a third array, or you can use a utility to
move/expand the partitions. If you take the latter step, you should be
able to convert your raid-5 to a raid-6 (I'll let the experts chime in
on that). You can then expand the array to use all the available space,
and expand the filesystem on the array to use it.

NB: If you don't get a perfect ddrescue copy, can you please email me
the log files - especially where it logs the blocks it can't copy. One
of the things I want to do is work out how to write that utility
mentioned on the "programming" page of the wiki.

Cheers,
Wol

