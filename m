From: Maarten <maarten@ultratux.net>
Subject: Re: RAID5 on different sized disks on low-end machine
Date: Tue, 11 Jan 2005 20:10:05 +0100
Message-ID: <200501112010.05469.maarten@ultratux.net>
References: <eaa6dfe050111104772af6240@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe050111104772af6240@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 11 January 2005 19:47, Derek Piper wrote:

> My question is this, is it possible (and even a good idea) to use all
> 4 hard drives as members of a 4 x 60GB RAID5 array by leaving 20GB of
> the 80GB drive as a non-raided partition? I'll be using a Promise
> Ultra TX2/100 controller.

That's perfectly okay.

> i.e. RAID5 = 180GB usable size,wherease RAID6 = 120GB .. am I correct
> in my thinking?

Yes.

> I know many of you use far larger hard drives, I'm just trying to use
> the components I already had spare from a number of machines and
> reorganize to a RAID-backed fileserver.

My first raid was a raid-0 from two 4.5 GB scsi disks...
My first raid at home was on 4x40GB drives, raid5.

> The machine is a dual pentium-pro 200 (320MB RAM) .. would that be a
> dumb idea to use RAID5 on it because of the parity calculations
> needed?

That raid-5 array above ran on a K6-300...  may not be fast but you can almost 
be sure that a 100Mbit ethernet is still slower...

> Further to that, would it be a smarter idea to use RAID1 on all 4 of
> some small partition(s) at the start of the disks to house
> boot/root/usr partitions, and only RAID5 on a larger 'data' area of
> the drive that is more likely to be read than written to?

YES !  If only because it is very hard to boot from raid-5.
But you could use that spare 20GB for the OS, couldn't you ?
Unless you want that redundant too.

Maarten

