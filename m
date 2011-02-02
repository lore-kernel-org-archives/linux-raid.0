From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Software RAID and Fakeraid
Date: Wed, 02 Feb 2011 10:34:09 -0500
Message-ID: <4D497971.4090709@cfl.rr.com>
References: <4CF81A16.2010606@cfl.rr.com>	<20101203123615.6edce071@notabene.brown>	<4CF860EB.7010005@cfl.rr.com>	<20101209094354.4c6aaa93@notabene.brown>	<4D01328D.9050503@cfl.rr.com>	<4D46E6D7.2000205@cfl.rr.com>	<20110131170349.GR343@caffeine.csclub.uwaterloo.ca>	<4D470BCF.20508@cfl.rr.com>	<20110131221252.GT343@caffeine.csclub.uwaterloo.ca>	<4D47627A.1080509@cfl.rr.com>	<20110201162642.GU343@caffeine.csclub.uwaterloo.ca>	<4D48A069.8010202@cfl.rr.com> <20110202142233.79940092@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110202142233.79940092@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: The development of GNU GRUB <grub-devel@gnu.org>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/1/2011 10:22 PM, NeilBrown wrote:
> There is a difficulty in case 2 as it is not clear who's responsibility it is
> to write a partition table at the start of each device.
> Presumably GRUB doesn't like to write partition tables unless one already
> exists.

Yes, it preserves the existing partition table and just modifies the
boot loader code in the MBR.

> Currently mdadm doesn't write a partition table either.  Possibly it could,
> but I would rather avoid that if possible.
> Maybe once case 2 has been clearly identified, GRUB could consider that
> sufficient permission to write a boot block and partition table even if no
> partition table existed??

Possibly, but that is the kind of thing I think should require an
explicit request.  Whether it is done by mdadm or not, I think that
someone should write a protective mbr.  Since mdadm is what is
effectively formatting the disk, it makes the most sense to me to do it
there, rather than in grub, which is just trying to install a boot
loader to an existing disk.  I suppose the OS installer could add the
MBR before asking mdadm to add its superblocks too.  What partition type
would be appropriate to use?

> In the 'reserved' case, mdadm would also report where the space is. e.g.
> 
>  MD_BOOT_SPACE="/dev/sda 8192 32768"
> 
> means that from byte offset 8192 there is 32768 bytes of available space.
> I would need to make sure that mdadm kept that space available, so I would
> need to know how much to reserve.  Maybe 32K.  Maybe 1M is safe?

Sounds good.  Grub is used to operating with 32k or less since that is
the historical amount of free space following the MBR.

> However there is another complication.
> I understand that the boot block sometimes lives at the start of the
> partition instead of (or as well as) the start of the device.
> I'm fairly syslinux does this - I don't know about GRUB.
> So I really want to still report BIOS or 'reserved' or 'no' even when
> partitions are in use.

Grub can be installed to the partition boot block, but it is strongly
discouraged since there is no gap to embed the core into, so the boot
block must use block lists to locate it.  This comes with all kinds of
headaches, including not being possible at all on some filesystems, and
frequently breaking on others.  Either way you still have to have boot
code in the MBR to go load the partition boot block, so I don't think
that changes anything with respect to this discussion.

> So maybe I should scrap case 0 (MD_BOOTABLE=partitions), assume that the
> boot-loader configurer can detect and understand partitions itself, and just
> report the other 3 cases ignoring the details about partitions.
> 
> Would that be helpful?  Would it get used?  How could it be better?

Yes, it sounds quite helpful.
