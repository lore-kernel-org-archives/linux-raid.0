From: "John Stoffel" <john@stoffel.org>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 14:50:21 -0500
Message-ID: <22090.13181.60012.260208@quad.stoffel.home>
References: <22090.1097.258820.65463@quad.stoffel.home>
	<564A1628.3080802@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <564A1628.3080802@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Robert" == Robert L Mathews <lists@tigertech.com> writes:

Robert> On 11/16/15 8:28 AM, John Stoffel wrote:
>> I'm starting to get tons of errors on my various mixed 1 and 2Tb
>> drives I have in a bunch of RAID 1 mirrors, generally triple mirrors.
>> It's time to start replacing them and I think I want to either go with
>> the WD Black 4Tb or the WD Red 4Tb drives.  And with a pair of 500Gb
>> SSDs to use with lvmcache for speedup.

Robert> I have no comment on the Red vs Black, but I do have
Robert> experience with a caching setup that's similar to this, but
Robert> simpler.

Robert> Replacing one disk of a triple RAID1 array with an SSD, and
Robert> marking the other two spinning disks "write-mostly", vastly
Robert> improves the performance of the entire array in a read-heavy
Robert> environment, with no extra caching layer required.

This is a great idea, and I'd go this route myself since I already
triple mirror my importand disks, but since I've already got 3Tb (1Tb
x 3, 2Tb x 3) disks in my setup, I'm looking for:

A) more space
B) cost is a prime factor
C) robust reliability

So my investigation of bcache and lvmcache has me leaning towards
lvmcache, if only because I can add it in without having to re-do my
entire setup and migrate data around.

For example, if I take out two disks, a 1Tb and 2Tb and then add in a
pair of 4Tb disks mirrored, I can then migrate my LVs over (and take
the downtime on one VolGroup with the 1Tb disks since it's less used
data...) and keep the system up and running.

Then I can shutdown, remove the 4 old disks, put in the 2 x 500gb
SSDs, and then bring things up, move stuff around, add lvmcache live,
etc.

Robert> It drops the read latency to almost zero in all cases, as you
Robert> would expect. But it also improves the write latency
Robert> significantly, because when a write occurs, it will never be
Robert> queued behind a spinning disk read: the spinning disks are
Robert> more likely to be idle when they receive the writes.

Robert> In our case, where the problem was mostly high latencies from
Robert> disk seeks in a read-heavy environment (not slow throughput
Robert> reading/writing large files), adding a single SSD reduced the
Robert> overall average combined read/write "await" latency by more
Robert> than 50%.

I'm more of a home NAS setup with my doing compiles, mail, light web
development, backups using bacula, mysql, KVMs, etc.  So it's a fairly
mixed and low stress environment.  But I'm now getting bombarded with
all kinds of warnings about bad blocks and I'm losing multiple
disks.... so it's time to seriously look into replacements.  

Robert> I considered this preferable to an extra-layer caching
Robert> solution because: 1) Reads of *all* files are from the SSD,
Robert> not just some files; 2) It's conceptually simpler than an
Robert> extra caching layer so there's less to go wrong; 3) It didn't
Robert> even require a reboot to implement with hot-swap disks; 4) Our
Robert> eventual goal was to replace all spinning disks in the arrays
Robert> with SSDs as they reach their lifetime anyway, and it would be
Robert> extra work to remove the caching layer when that was done.
Robert> (Interestingly, when we did later replace the other two
Robert> spinning disks with SSDs, it made less difference than adding
Robert> the first SSD.)

All these points are excellent.  It all founders on the cost of a 3Tb
SSD.  :-)

Robert> If your environment is write-heavy, a cache layer to intercept all
Robert> writes may make more sense, of course.

Robert> -- 
Robert> Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
Robert> --
Robert> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
Robert> the body of a message to majordomo@vger.kernel.org
Robert> More majordomo info at  http://vger.kernel.org/majordomo-info.html
