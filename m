From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Software RAID and Fakeraid
Date: Thu, 09 Dec 2010 14:48:29 -0500
Message-ID: <4D01328D.9050503@cfl.rr.com>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>	<4CF55680.5010703@cfl.rr.com>	<20101201092508.7023f974@notabene.brown>	<4CF81A16.2010606@cfl.rr.com>	<20101203123615.6edce071@notabene.brown>	<4CF860EB.7010005@cfl.rr.com> <20101209094354.4c6aaa93@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209094354.4c6aaa93@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: The development of GNU GRUB <grub-devel@gnu.org>, John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/8/2010 5:43 PM, Neil Brown wrote:
> Could you install to both??  Maybe not...

For a fakeraid raid1 you could do both, or either.  For a conventional
md raid1, or a fakeraid raid0 ( or raid5/6 ) you can not.

> What exactly needs to be installed?  My understanding is that you need to
> install a boot block which cal load a larger chunk from some fixed location,
> and the larger chunk understands raid and filesystems and everything and can
> figure out what to do.
> Where do you install that larger chunk??

The larger chunk is called the core image in grub terminology.  It is
generated during installation and written to /boot/grub/core.img and
contains the main kernel plus all disk, filesystem, and abstraction
modules required to access /boot/grub and load more modules and the
config file from there.  The MBR can be written with blocklists directly
pointing to that file, but this is inherently unreliable ( and not even
possible on some filesystems that do things like tail packing ) so it is
preferred to copy the core image to the embed area immediately following
the MBR, or to the BIOS boot partition if you are using GPT.

> I'd be happy to get mdadm to provide useful information for grub if I knew
> what information was needed, and knew that grub would use it.
> It would probably be an extension to "mdadm --detail --export".

What grub really needs to know is whether or not the array is accessible
via the bios int 13.  If it is not, then we need to figure out which
abstraction modules are needed to access the array ( md and possibly lvm
), build them into the core image, and install the mbr and core image to
the underlying physical disks.  If it is an int13 device, then the md
module is not required.

If mdadm --detail --export lists the metadata type being used, we can
probably use that to infer whether it is conventional md metadata, or
fakeraid metadata, and thus assume int13 access, but it might be better
to get a more explicit statement from mdadm about whether it is fakeraid
or some kind of pure software raid, whether it be conventional md or
otherwise.

Things get a little tricky with md using the whole disks instead of
partitions in them.  In that case, it is simply not possible to install
grub if using 1.1.  For 0.9 and 1.0, it is possible iff it is a
partitioned array and therefore, the primary component disk appears to
have a valid partition table and embed area and the stripe size is >=
32k ( except for raid1 ).  Even then it is only possible to install grub
to the primary disk, which obviously means you can not boot if that disk
fails, so this isn't a desirable setup.

I suppose it could be possible to install with 1.2, if mdadm can point
grub to a location it can install the core to, instead of the embed area
( since the md metadata is there ).  This would probably be the leftover
space at the end of the disk, that is not part of a stripe ( but still
needs to be >= 32k ).  This would even allow you to install to all
components and have redundant boot from each of them.
