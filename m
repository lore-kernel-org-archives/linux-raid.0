From: Steven Ihde <x-linux-raid@hamachi.dyndns.org>
Subject: Re: LVM on top of software raid5
Date: Sat, 4 Dec 2004 13:57:41 -0800
Message-ID: <20041204215741.GA7828@hamachi.dyndns.org>
References: <c7c98a00412031639292ce21b@mail.gmail.com> <200412042122.iB4LMr8H024129@ms-smtp-02-eri0.texas.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200412042122.iB4LMr8H024129@ms-smtp-02-eri0.texas.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Unruh <jeff@jdubya.org>
Cc: 'Steven Joerger' <steven.joerger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


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
> A little googling will help.  I am running a gentoo box using raidtools with
> 3x200 Seagate Drives in a Raid5 array with LVM2 (I know - I need to convert
> to mdadm but not sure how).
> 
> Here are a few links that helped me out - using LVM2.
> 
> http://www.gentoo.org/doc/en/lvm2.xml
> 
> http://www.tldp.org/HOWTO/LVM-HOWTO/
> 
> I am using /dev/md2 (/dev/vg0) as my music and video repository and it is
> ever growing so LVM is helpful to manage the size and expand when necessary.
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

