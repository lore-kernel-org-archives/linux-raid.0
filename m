From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: small mdadm issue under debian
Date: Thu, 29 Oct 2009 11:20:24 -0600
Message-ID: <200910291120.24803.tfjellstrom@shaw.ca>
References: <200910290124.59090.tfjellstrom@shaw.ca> <200910290130.18829.tfjellstrom@shaw.ca> <70ed7c3e0910290526v93752bfv3b5acb1a3b3f4e52@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910290526v93752bfv3b5acb1a3b3f4e52@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu October 29 2009, Majed B. wrote:
> When using newer kernels, did you update initrd?
> 
> sudo update-initramfs -u -k all

Yes I did.

> Then reboot to a new kernel and see if it auto assembles.

I don't have them auto assemble in initrd/initramfs. Its done later in the 
mdadm-raid script if I read it correctly. Its also a 1.1 metadata array, so 
the kernel can't auto assemble it itself.

Just somehow it fails to build under 2.6.29+ but works fine under 2.6.26 
with the same userspace.

> On Thu, Oct 29, 2009 at 10:30 AM, Thomas Fjellstrom <tfjellstrom@shaw.ca> 
wrote:
> > On Thu October 29 2009, Thomas Fjellstrom wrote:
> >> I've been trying to get mdadm to auto assemble my raid array for a
> >> while now, and as I'm trying to test which kernels give me back some
> >> performance (testing 2.6.26 right now), I find that with this kernel,
> >> its happily auto assembling my 1.1 versioned metadata array. 3.6.30
> >> does not, nor does .31 or .32 for that matter. Same version of mdadm,
> >> for some reason, when the mdadm-raid init script is run, it fails to
> >> assemble the raid array I've specified in mdadm.conf. And again, it
> >> automagically works with 2.6.26.
> >>
> >> color me confused.
> >
> > I totally forgot:
> >
> > root@natasha:/home/moose# mdadm --version
> > mdadm - v3.0.3 - 22nd October 2009
> >
> > root@natasha:/home/moose# uname -a
> > Linux natasha 2.6.26-2-amd64 #1 SMP Wed Aug 19 22:33:18 UTC 2009 x86_64
> > GNU/Linux
> >
> > root@natasha:/home/moose# mdadm -D /dev/md0
> > /dev/md0:
> >        Version : 1.01
> >  Creation Time : Wed Oct 14 08:55:25 2009
> >     Raid Level : raid5
> >     Array Size : 3907049472 (3726.05 GiB 4000.82 GB)
> >  Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
> >   Raid Devices : 5
> >  Total Devices : 5
> >    Persistence : Superblock is persistent
> >
> >    Update Time : Thu Oct 29 01:28:10 2009
> >          State : clean
> >  Active Devices : 5
> > Working Devices : 5
> >  Failed Devices : 0
> >  Spare Devices : 0
> >
> >         Layout : left-symmetric
> >     Chunk Size : 512K
> >
> >           Name : natasha:0  (local to host natasha)
> >           UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
> >         Events : 4952
> >
> >    Number   Major   Minor   RaidDevice State
> >       0       8       64        0      active sync   /dev/sde
> >       1       8       80        1      active sync   /dev/sdf
> >       2       8       32        2      active sync   /dev/sdc
> >       3       8       48        3      active sync   /dev/sdd
> >       5       8       96        4      active sync   /dev/sdg
> >
> >
> > And I'm running Debian Sid.
> >
> > --
> > Thomas Fjellstrom
> > tfjellstrom@shaw.ca
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
