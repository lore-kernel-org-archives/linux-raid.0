From: Neil Brown <neilb@suse.de>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 13:16:44 +1000
Message-ID: <19141.28828.24109.570050@notabene.brown>
References: <babafd2f0910011827l2bc62facpc5fe15ab3994b512@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ben DJ on Thursday October 1
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 1, bendj095124367913213465@gmail.com wrote:
> I'm setting up new linux boxes, hoping to install whatever OS I choose
> to a software RAID array.
> 
> I've got 4 identical SATA drives, and would ideally like to use RAID-10.
> 
> I've read a bunch of slightly stale How-To docs, and have a few questions.
> 
> (1) Can Linux boot from /boot on RAID-10?  Oldest info I found said no
> boot from RAID at all, then more recent docs said boot from RAID-1
> works.  I found nothing on RAID-10.  What's the latest sccop on this?

Linux doesn't boot.  Something else has to boot Linux.
So the question really is:
  Can Lilo, or grub, or grub2 or whatever boot on RAID-10.

It is possible that grub2 can or will be able to one day, but I think
the safest answer to work with at the moment is "no".

> 
> (2) As far as I can tell, none of the installers in Centos, Ubuntu or
> Opensuse are RAID-10 aware.  Seems like the sanest way to get setup
> would be to boot from SystemRescueCD, do the partitioning and RAID
> creation, then re-boot from an installer disk using the pre-setup
> disks.
> 
> Am I missing some other, simpler approach?

I haven't used any of those installers in ages but I wouldn't be
surprised if what you say is true.  Your "sanest way" suggestion is
the approach that I would probably take.

> 
> (3) Assuming that I'll have to boot from RAID-1 (Just suspect that
> RAID-10 is not yet an option for /boot, but willing to be shown
> wrong!), I'm considering 3 partitioning/raid_config options,
> 
>   (a)
>     DISK1      DISK2      DISK3      DISK4
>    [ RAID-1  /boot                        ]
>    [ RAID-1  swap                         ]
>    [ RAID-10 LVM, /root & 'other' parts   ]
> 
>   (b)
>     DISK1      DISK2      DISK3      DISK4
>    [ RAID-1  /boot  ]    [ RAID-1  swap   ]
>    [ RAID-10 LVM, /root & 'other' parts   ]
> 
>   (c)
>     DISK1      DISK2      DISK3      DISK4
>    [ RAID-1  /boot                        ]
>    [ RAID-10 LVM, /root, swap & 'other'   ]
> 
> Are there any clear benefits/concerns of one config over the other?

I would probably go for 'c' as it is most flexible.  If, however, you
are going to be hitting swap a lot, and cannot afford extra memory,
'a' might be the better option.
It isn't really a lot between them.

> 
> (4) In setting up the RAID arrays, I've got a choice of metadata
> versions.  It seems that the distros' installers default to "1.0", but
> that "1.1" & "1.2" are both available, too.
> 
> Should I just use the newest, 1.2?  Any problems if I do?

1.2 isn't "newer".  1.0, 1.1, 1.2 are similar but put the metadata in
different places.
I has been suggested that we call them 1.end, 1.start and 1.offset (or
something like that) and while it might be a good idea, it hasn't
happened.

You almost certainly want 1.0 for /boot otherwise you probably won't
be able to boot.  I would suggest 1.1 for your RAID10.

> 
> (5) In whatever config is "best" in (3), above, is it still good
> advice to install the bootlader into multiple MBRs? For example, if I
> extend the RAID-1 over all 4-disks, then, I install the loader into
> all four MBRs?

Yes.  Else you might be able to boot if the first device dies.

Good luck,
NeilBrown
