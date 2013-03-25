From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Mon, 25 Mar 2013 17:44:19 -0600
Message-ID: <4C0D23B0-8ABA-4086-BF42-774EF7F0C817@colorremedies.com>
References: <515089B1.9010607@gmail.com> <51509025.2060402@gmail.com> <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com> <5150DC08.8000702@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5150DC08.8000702@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 25, 2013, at 5:21 PM, maurice <mhilarius@gmail.com> wrote:
> 
> Is there any problem with installing CentOS directly on an array in RAID10, as opposed to on to "regular" partitions?

Oh that's a totally different scenario. I thought you wanted the raid10 array for /home or /data or whatever. That's pretty messy, actually, even on Fedora 18/19 which has the benefit of a new anaconda and GRUB2. GRUB2 definitely can assemble md raid10, and read most any file system, find /boot, and load the kernel and initramfs. That's not something I think GRUB Legacy can do, which is what CentOS 6 is using.

I don't know off hand if partitionable arrays are supported by GRUB2. I haven't tested this. And even if GRUB2 does recognize the partitioned array, the initramfs I think needs kpartx built into it, in order for the kernel to have the ability to find and then mount rootfs. And even if all of that it true, I don't think anaconda new or old will let you install the system the way you're thinking. Fedora 18/19's anaconda does not see arrays, it sees actual physical drives. And it wants to create partitions on those devices, not partitions on the array. It might be possible to do what you want via kickstart.

I have successfully created a bootable raid 10, where /boot, /, /home were all on a four disk raid10. But that's with Fedora 18, which uses GRUB2.

I'm unsure of your use case, but I'm thinking you may be better off with a small SSD for the boot, swap and system disk, and then use a separate raid10 array for /home, /opt, /data, whatever else you want. Otherwise it's a bit of a rabbit hole.


Chris Murphy