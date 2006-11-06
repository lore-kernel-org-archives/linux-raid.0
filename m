From: Thomas Andrews <tandrews@grok.co.za>
Subject: Re: invalid (zero) superblock magic upon creation of a new RAID-1 array
Date: Mon, 6 Nov 2006 08:42:33 +0200
Message-ID: <20061106064233.GA2793@grok.co.za>
References: <20061105085702.GD20184@grok.co.za> <17742.25334.685135.990170@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17742.25334.685135.990170@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, Nov 06, 2006 at 09:17:26AM +1100, Neil Brown wrote:

> On Sunday November 5, tandrews@grok.co.za wrote:

> > Why would the superblock magic be zero on a newly created RAID-1 set?
> > 
> > I get this error when the kernel (2.6.17.7) boots:
> > 
> >     md: Autodetecting RAID arrays.
> >     md: invalid raid superblock magic on sda1, found 0x0 not 0xa92b4efc
> >     md: sda1 has invalid sb, not importing!
> >     md: invalid raid superblock magic on sda2, found 0x0 not 0xa92b4efc
> >     md: sda2 has invalid sb, not importing!
> >     md: invalid raid superblock magic on sdb1, found 0x0 not 0xa92b4efc
> >     md: sdb1 has invalid sb, not importing!
> >     md: invalid raid superblock magic on sdb2, found 0x0 not 0xa92b4efc
> >     md: sdb2 has invalid sb, not importing!
> >     md: autorun ...
> >     md: ... autorun DONE.
> > 
> > (I modified md.c so that it prints out "found xxxx not 0xa92b4efc")
> > 
> > I have a monolithic kernel, compiled for RAID-1.
> > 
> > Once the system is up and running, mdadm brings up the RAID arrays fine:
> > 
> >     # cat /proc/mdstat
> >     Personalities : [raid1] 
> >     md1 : active raid1 sda2[0] sdb2[1]
> >           506036 blocks super 1.0 [2/2] [UU]
>                           ^^^^^^^^^
> 
> in-kernel autodetect (based on partition types FD) only works for
> version 0.90 superblocks.
> 
> You mdadm to assemble the array, it is more flexible than auto-detect.

Thanks Neil, I fixed my problem by creating the raid set using the "-e"
option:

    mdadm -C /dev/md0 -e 0.90 --level=raid1 --raid-devices=2  /dev/sda1 /dev/sdb1

You're suggestion to use mdadm to assemble the array is not an option
for me because it is the root partition that is raided, but thanks for
putting me in the right direction.

Regards,
Thomas
