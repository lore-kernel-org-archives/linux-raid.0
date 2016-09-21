From: Simon Becks <beckssimon5@gmail.com>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with xfs
 filesystem by accident
Date: Wed, 21 Sep 2016 21:50:45 +0200
Message-ID: <CAKA=zHryc+hqie_VZDsU4HGQP9Cw7Oo_J3S4mjJHyZbGX1K1PA@mail.gmail.com>
References: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
 <CAJCQCtR4NoCebcDLD-ovT+hZY=NKRtj1cP693wHQTbmiERDAXw@mail.gmail.com>
 <CAKA=zHpgVoNA5Y6MBmB4fnG85F-z=hj4FXEiUOggsWUn3tfWXg@mail.gmail.com>
 <20160921171511.GA6381@metamorpher.de> <CAKA=zHq7OgZ+oVAqn7zVmBM0gSQedNk2kZ3dkuBG7V89G-G3Rg@mail.gmail.com>
 <20160921180318.GA6633@metamorpher.de> <CAKA=zHoJu2vTXQa4yvbJDA2nmQwXLHyw2DfUJ+cVgTDr_gu2XQ@mail.gmail.com>
 <20160921190035.GA6949@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160921190035.GA6949@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you. I already learned a lot. Your command only shows data for
all of the 3 disks.

Out of curiosity i used strings /dev/loop42 | grep mp3 and many of my
songs showed up - is that a good sign?

Just tried the 5 orders like a,b,c a,c,b and so on and receive the
same output about mount: wrong fs type, bad option, bad superblock on
/dev/md42 and fsck.ext2: Superblock invalid, trying backup blocks....

Then used photorec in all 5 combinations of disks for several minutes
without a single file found.

Is it possible that i have to keep something else in mind, while
assembling the raid? I expected at least some files with photorec when
the raid was assembled in the right order.


2016-09-21 21:00 GMT+02:00 Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> On Wed, Sep 21, 2016 at 08:31:23PM +0200, Simon Becks wrote:
>> Maybe i just assembled it in the wrong order?
>
> Yes, or maybe the superblock was overwritten by XFS after all.
>
> You could check what's at offset 1M for each disk.
>
> losetup --find --show --read-only --offset=$((2048*512)) /the/disk
> file -s /dev/loop42
>
> If the superblock was still intact it should say ext4 or whatever
> your filesystem was for at least one of them.
>
> You can also try this for the disk you removed 2 month ago.
>
> If that is not the case and fsck with backup superblock also
> is not successful then you'll have to see if you find anything
> valid in the raw data.
>
> Regards
> Andreas Klauer
