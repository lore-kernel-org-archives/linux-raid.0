From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Adding a new mirror disk to RAID1 configuration
Date: Fri, 9 Jul 2004 15:13:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16622.10619.858746.286769@cse.unsw.edu.au>
References: <40EE251C.3060903@neuro-tech.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luke Reeves on Friday July 9
To: Luke Reeves <luke@neuro-tech.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 9, luke@neuro-tech.net wrote:
> I have a system with two 40GB drives, and the first drive (hda) is setup 
>   under an md device with RAID1 driving it.  I'm trying to now make the 
> second disk, hdc, a mirror of the first.  When I try to add it using 
> mdadm the second disk becomes a spare and no synchronization is done. 
> Is there any way to add the second disk directly as a mirror?  Thanks.

If you have a very recent 2.6 kernel and very recent mdadm, then you
can

   mdadm --grow /dev/md0 --raid-disks 2

to tell it that there should really be 2 raid disks, and then the
spare will start synchronising.

Otherwise you will need to recreate the array telling that you really
wanted it to have to raid disks (one missing or failed) in the first
place.

This is assuming that it currently thinks it has one raid-disk.
A
  cat /proc/mdstat
or
  mdadm -D /dev/md0

would help.

NeilBrown
