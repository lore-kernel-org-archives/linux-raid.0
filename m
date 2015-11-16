From: Robert L Mathews <lists@tigertech.com>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 09:45:12 -0800
Message-ID: <564A1628.3080802@tigertech.com>
References: <22090.1097.258820.65463@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22090.1097.258820.65463@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/16/15 8:28 AM, John Stoffel wrote:

> I'm starting to get tons of errors on my various mixed 1 and 2Tb
> drives I have in a bunch of RAID 1 mirrors, generally triple mirrors.
> It's time to start replacing them and I think I want to either go with
> the WD Black 4Tb or the WD Red 4Tb drives.  And with a pair of 500Gb
> SSDs to use with lvmcache for speedup.

I have no comment on the Red vs Black, but I do have experience with a
caching setup that's similar to this, but simpler.

Replacing one disk of a triple RAID1 array with an SSD, and marking the
other two spinning disks "write-mostly", vastly improves the performance
of the entire array in a read-heavy environment, with no extra caching
layer required.

It drops the read latency to almost zero in all cases, as you would
expect. But it also improves the write latency significantly, because
when a write occurs, it will never be queued behind a spinning disk
read: the spinning disks are more likely to be idle when they receive
the writes.

In our case, where the problem was mostly high latencies from disk seeks
in a read-heavy environment (not slow throughput reading/writing large
files), adding a single SSD reduced the overall average combined
read/write "await" latency by more than 50%.

I considered this preferable to an extra-layer caching solution because:
1) Reads of *all* files are from the SSD, not just some files; 2) It's
conceptually simpler than an extra caching layer so there's less to go
wrong; 3) It didn't even require a reboot to implement with hot-swap
disks; 4) Our eventual goal was to replace all spinning disks in the
arrays with SSDs as they reach their lifetime anyway, and it would be
extra work to remove the caching layer when that was done.
(Interestingly, when we did later replace the other two spinning disks
with SSDs, it made less difference than adding the first SSD.)

If your environment is write-heavy, a cache layer to intercept all
writes may make more sense, of course.

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
