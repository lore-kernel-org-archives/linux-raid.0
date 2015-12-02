From: keld@keldix.com
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Wed, 2 Dec 2015 02:07:45 +0100
Message-ID: <20151202010745.GC9812@www5.open-std.org>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dallas

Did you test the performance of other raid types, such as RAID1 and the various
layouts of RAID10 for the newer kernels?

Best regards
keld

On Tue, Dec 01, 2015 at 05:02:27PM -0600, Dallas Clement wrote:
> Hi,
> 
> I have a NAS system with 12 spinning disks that has been running with
> the 2.6.39.4 kernel. It has a 4 core xeon processor (E31275 @
> 3.40GHz), with 8 GB of RAM.  The 12 disks in my RAID array are Hitachi
> 4 TB, 7200 RPM SATA drives.  The filesystem is XFS.
> 
> Recently I have been evaluating RAID performance on newer kernels 3.10
> and 4.2.  I have observed that with the same settings, I am seeing
> much slower RAID 5 and 6 sequential write speeds with newer kernels
> compared to what I was seeing with the 2.6.39.4 kernel.  However, the
> 4.2 kernel has much better read speeds for both sequential and random
> patterns.  I understand that there have been many improvements to RAID
> 5 and 6 in the 4.1 kernel.  I definitely am seeing improvement with
> reads but not writes.
> 
> If I observe disk and array throughput with iostat, the individual
> disk utilization and wMB/s is much lower in the newer kernels.  With
> the older 2.6.39.4 kernel, disk utilization seems to stay above 80%
> with wMB/s around 74 MB/s, whereas the newer kernel disk utilization
> seems to vary between 20-70% with wMB/s around 9-38 MB/s.  CPU iowait
> gets up to about 10% much of the time.  These Hitachi disks are
> capable of sustaining around 170 MB/s, which is just about what I see
> when doing sequential writes to all 12 disks concurrently in a JBOD
> configuration, i.e no RAID.  The iowait for 12 disks of JBOD gets up
> to about 97% - which makes the system very unresponsive.
> 
> One other observation is that RAID 0 sequential write speeds in newer
> kernels are only slightly less than what I was seeing in 2.6.39.4.
> 
> I am frankly surprised at these results.  Perhaps there is some
> configuration or tunable settings that have changed since the 2.6
> kernel that I am unaware of that affect RAID 5, 6 performance.  Please
> comment if you have any ideas which might explain what I am seeing.
> 
> Thanks,
> 
> Dalla
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
