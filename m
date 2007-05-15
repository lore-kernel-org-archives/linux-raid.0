From: Neil Brown <neilb@suse.de>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 20:16:47 +1000
Message-ID: <17993.34959.150157.200536@notabene.brown>
References: <4649760A.1060805@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomasz Chmielewski on Tuesday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 15, mangoo@wpkg.org wrote:
> 
> Now, is there a way I can synchronize the contents of RAID-10, or 
> /dev/md10, with the contents of RAID-5, or /dev/sdr, when /dev/sdr is 
> bigger then /dev/md10, and /dev/md10 has to be synchronized on /dev/sdr, 
> not the way around (I would expand the filesystem later with ext3online)?

Yes, you can do this.

You want a raid1 with no metadata, an external bitmap, and a
write-mostly, write-behind device.  Simple?

No metadata means no superblock is stored on the device.  You get to
use all of it for data, which is good if it is already all in use for
data.
The down-side of not having a superblock is that you have to track
which device is which yourself and after a restart, manually assemble
it.  But for a short-term situation, that isn't a big problem.

An external bitmap means that if the link goes down, it keeps track of
which blocks are in sync and which aren't, and when the link comes
back up you re-add the missing device and the rebuild continues where
it left off.

A write-mostly device means that it will never read over the slow link
(unless the local device dies).  It will only write over the slow
link.

A write-behind device means that writes to the array will be as fast
as writes to the local device.  There are limits to this.  Long-term,
the write throughput will be limited to the slowest device, but bursts
to the array will happen at the full speed of the local device.

How do you do this?  First make sure you have a recent kernel and
mdadm.

Then you build the array with

  mdadm --build /dev/md22 --level=1 --bitmap=/root/mybitmap \
     --write-behind --raid-disks=2 /dev/localdevice --write-mostly /dev/remotedevice

then use /dev/md22 instead of /dev/localdevice.
This will not destroy the contents of /dev/localdevice.  They will
remain unchanged.  But it will start copying those contents to /dev/remotedevice

Obviously you need to unmount /dev/localdevice first, then set up the
raid1, then mount /dev/md22 in it's place.

You will want to test this of course - I cannot guarantee that I have
that command exactly right.

If the remote device fails (link breaks) it should get marked faulty
in the array.  Once you have it working again you can use mdadm to
remove (--remove) and re-add (--re-add) the device.  It should
complete the copy correctly.   You should test that this actually
works as expected. 

Feel free to ask questions if you choose to attempt this route.

Good luck.

NeilBrown
