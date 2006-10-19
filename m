From: Neil Brown <neilb@suse.de>
Subject: Re: Propose of enhancement of raid1 driver
Date: Thu, 19 Oct 2006 13:28:40 +1000
Message-ID: <17718.61672.794099.425723@cse.unsw.edu.au>
References: <45347D6E.3000600@mieszczak.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Miroslaw Mieszczak on Tuesday October 17
Sender: linux-raid-owner@vger.kernel.org
To: Miroslaw Mieszczak <mirek@mieszczak.com.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 17, mirek@mieszczak.com.pl wrote:
> I would like to propose an enhancement of raid 1 driver in linux kernel.
> The enhancement would be speedup of data reading on mirrored partitions.
> The idea is easy.
> If we have mirrored partition over 2 disks, and these disk are in sync, there is
> possibility of simultaneous reading of the data from both disks on the same way
> as in raid 0. So it would be chunk1 read from master, chunk2 read from slave at
> the same time. 
> As result it would give significant speedup of read operation (comparable with
> speed of raid 0 disks).

This is not as easy as it sounds.
Skipping over blocks within a track is no faster than reading blocks
in the track, so you would need to make sure that your chunk size is
larger than one track - probably it would need to be several tracks.

Raid1 already does some read-balancing, though it is possible (even
likely) that it doesn't balance very effectively.  Working out how
best to do the balancing in general in a non-trivial task, but would
be worth spending time on.

The raid10 module in linux supports a layout described as 'far=2'.
In this layout, with two drives, the first half of the drives is used
for a raid0, and the second half is used for a mirrored raid0 with the
data on the other disk.
In this layout reads should certainly go at raid0 speeds, though
there is cost in the speed of writes.

Maybe you would like to experiment.  Write a program that reads from
two drives in parallel, reading all the 'odd' chunks from one drive
and the 'even' chunks from the other, and find out how fast it is.
Maybe you could get it to try lots of different chunk sizes and see
which is the fastest.

That might be quite helpful in understanding how to get read-balancing
working well.

NeilBrown
