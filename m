From: Gavin McCullagh <gmccullagh@gmail.com>
Subject: Re: mismatch_cnt worries
Date: Tue, 3 Apr 2007 09:16:43 +0100
Message-ID: <20070403081643.GB32302@gmail.com>
References: <20070402144509.GB21405@gmail.com> <17937.39220.736583.474597@notabene.brown>
Reply-To: Gavin McCullagh <gmccullagh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17937.39220.736583.474597@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

thanks for the reply.

On Tue, 03 Apr 2007, Neil Brown wrote:

> If you have a swap-partition or a swap-file on the device then you
> should consider it normal.  If not, then it is much less likely but
> still possible.

I see it on two machines' ext3 root filesystems.

> > 2. Should I repair, fsck, replace a disk, something else?
> 
> 'repair' is probably a good idea.

I ran 'repair', then 'check' and the count is still 128.  However, I'm
running 2.6.17 on ubuntu edgy (from October) so I'm guessing 'repair' is
still equivalent to check as you said here.

http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07269.html

> 'fsck' certainly wouldn't hurt and might show something, though I
> suspect it will find the filesystem to be structurally sound.

You're probably right.

> Suppose I memory-map a file and often modify the mapped memory.
> The system will at some point decide to write that block of the file
> to the device.  It will send a request to raid1, which will send one
> request each to two different devices.  They will each DMA the data
> out of that memory to the controller at different times so they could
> quite possibly get different data (if I changed the mapped memory
> between those two DMA request).  So the data on the two drives in a
> mirror can easily be different.  If a 'check' happens at exactly this
> time it will notice.
>
> So: if you are actively writing to a file while 'check' is running on
> a raid1, it could show up as a difference in mismatch_cnt.  But you
> have to get the timing just right (or wrong).

I presume then that if you run 'repair' all writes are flushed.  Just
thinking that in RAID1 where two blocks differ, one block gets chosen
arbitrarily as the correct one and the other gets overwritten.  Or should
'repair' ideally be run with the filesystem read-only?

> I think it is possible in the above scenario to truncate the file
> while a write is underway but with new data in memory.  .....

> Does that help explain the above quote?

Yes, thanks.

> It is still the case that:
>   filesystem corruption won't happen in normal operation
>   a small mismatch_cnt does not necessarily imply a problem.

Many thanks again for a very informative reply,

Gavin

