From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Sat, 3 Oct 2009 11:02:25 -0600
Message-ID: <200910031102.25567.tfjellstrom@shaw.ca>
References: <275143.15844.qm@web38804.mail.mud.yahoo.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <275143.15844.qm@web38804.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat October 3 2009, adfas asd wrote:
> --- On Fri, 10/2/09, Ben DJ <bendj095124367913213465@gmail.com> wrote:
> > On Fri, Oct 2, 2009 at 5:30 AM, adfas asd <chimera_god@yahoo.com>
> >
> > wrote:
> > >I've unplugged each drive and tried it, and they boot
> >
> > just fine degraded.
> >
> > That's great to hear.  Just curious, how many drives
> > in your array at the time?
> 
> Two disks, 2TB each.  RAID10-o2 means that there are two redundant copies
>  of my data in the array, stored respectively on sda and sdb.
> 
> > > I followed this guide, to convert my -running- Debian
> >
> > system, and just made a few substitutions for RAID10:
> > > http://www.howtoforge.com/software-raid1-grub-boot-debian-etch
> >
> > Thanks for the additional URL.
> >
> > In all these cases /boot on RAID-10 was on its own
> > partition, NOT on
> > /boot in a LVM-on-RAID, right?
> 
> I didn't use LVM, and don't trust layering of any technology.  My two-drive
>  array was set up much as he recommended it: md1 - / (including /boot), md2
>  - swap, md3 - /home.  I am against any further fracturing of partitions,
>  as modern disk drives have lots of space, and lots of parts becomes
>  unmaintainable.
> 
> I will say that this system appears to be a performance problem for me, as
>  I run MythTV on / and have my videos in /home.  When Myth is scanning to
>  eliminate commercials it must frantically sweep between / and /home, and
>  overall system performance is impacted.  I am working on putting / on a
>  dedicated high-performance 2.5" drive and keeping my videos on the array
>  as they're much too large to back up.  In the process I'm also going to
>  split the array so that one drive is in the PeeCee and the other is NASsed
>  out in the garage in case of theft or fire.
> 
> When I need more space (soon) I'll add two more drives, and still mirror
>  them two copies, with one side of the mirror in the PeeCee (sda, sdb) and
>  the other NASsed in the garage (sdc, sdd).
> 
> What I know is that 'offset' will boot and fail over.  I don't know if
>  'far' will.  I also know that .90 will boot and fail over.  I don't know
>  whether 1.x will.  When building the array I tried to use 1.2 (as I
>  thought it was newest/best) but there was a bitch at the beginning of boot
>  and it wouldn't boot (for other reasons) so I reverted to .90.  When I do
>  it again I will likely use 1.0, given what I've recently learned here.
> 
> I am still confused about the benefits of far vs offset.  Keld (the
>  developer) says that although offset is newer, it's not necessarily better
>  than far, only more compatible.  I have not found any rigorous performance
>  comparisons of far vs offset.
> 
> I am shocked to read that RAID10 is not expandable.  I will want to add
>  disks in the future. I will want to add space, but not partitions.  Does
>  this mean I'll have to completely rebuild the array?  Once your data gets
>  to a certain size it becomes unmanageable to rebuild the array.
> 

I'm assuming they just haven't had time to do it yet. the raid 10 module is 
fairly new, while the raid5/6 code has been around for ages. I'm hoping that 
by the time I need to expand my new raid10 array, there will be full expansion 
support like raid5 has.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
