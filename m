From: "Jeff Unruh" <jeff@jdubya.org>
Subject: RE: LVM on top of software raid5
Date: Sat, 4 Dec 2004 21:10:01 -0600
Message-ID: <200412050309.iB539WJ5015009@ms-smtp-04.texas.rr.com>
References: <20041204215741.GA7828@hamachi.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041204215741.GA7828@hamachi.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Steven Ihde' <x-linux-raid@hamachi.dyndns.org>
Cc: 'Steven Joerger' <steven.joerger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I should have mentioned I boot off a Raid-1 array with Grub and manually
update the 3rd disk's /boot ...

/dev/md0 (Raid 1) is 32 MB for /boot
/dev/md1 (Raid 5) is 4 GB for /
/dev/md2 (Raid 5 with LVM2 = /dev/vg0) is 366 GB for /home /usr /opt /var
and /tmp

I am sure that set-up is debatable, but it has worked well thus far. 

// Jeff

-----Original Message-----
From: Steven Ihde [mailto:x-linux-raid@hamachi.dyndns.org] 
Sent: Saturday, December 04, 2004 3:58 PM
To: Jeff Unruh
Cc: 'Steven Joerger'; linux-raid@vger.kernel.org
Subject: Re: LVM on top of software raid5


Two key points though:  

(1) booting off raid5 (whether lvm2 is involved or not) can be
    difficult to set up, if it's even possible.  Many folks (including
    me) use the approach of allocating the first 1G or so of each disk
    to a raid1 array (which can be booted from), and allocating the
    remainder of each disk to the raid5 array.  With a little
    trickery, you can set it up so that every disk in the array is
    bootable.

(2) LVM2 will certainly help you manange the existing space on your
    raid5 array.  You'd like to think that when your array fills up
    you can just add another disk to the raid5 array and grow it --
    but it's not that simple.  Growing a raid5 is somewhat complicated
    and dangerous because it involves shuffling around virtually every
    disk block and recomputing every parity block.  There is a program
    called raidreconf that does this, and some folks have reported
    success, but I've never tried it.  To be fair I've never heard a
    disaster story about this either, but there seems to be a sense of
    "unease" about doing this.  This functionality is not part of
    mdadm nor of raidtools.

Once you figure out how to set up the arrays, LVM2 is easy -- just add
/dev/md[whatever] as a PV for LVM2, and proceed as you would normally.

-Steve


On Sat, 04 Dec 2004 15:23:08 -0600, Jeff Unruh wrote:
> Steven,
> 
> A little googling will help.  I am running a gentoo box using raidtools
with
> 3x200 Seagate Drives in a Raid5 array with LVM2 (I know - I need to
convert
> to mdadm but not sure how).
> 
> Here are a few links that helped me out - using LVM2.
> 
> http://www.gentoo.org/doc/en/lvm2.xml
> 
> http://www.tldp.org/HOWTO/LVM-HOWTO/
> 
> I am using /dev/md2 (/dev/vg0) as my music and video repository and it is
> ever growing so LVM is helpful to manage the size and expand when
necessary.
> 
> 
> // Jeff
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Steven Joerger
> Sent: Friday, December 03, 2004 6:39 PM
> To: linux-raid@vger.kernel.org
> Subject: LVM on top of software raid5
> 
> Hello List,
> 
> Can anyone point me to a decent guide for setting up LVM on a software
> raid 5. I'm particularly interested in being able to grow the size of
> the raid at some point.
> 
> Thanks in advance.
> Steve
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


