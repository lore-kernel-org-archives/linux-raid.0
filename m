From: Phil Turmel <philip@turmel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 16:32:27 -0500
Message-ID: <5669EF6B.5090707@turmel.org>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
 <5669DB3B.30101@turmel.org>
 <CAE9DZUSNkLxaKH8MtggW+5_uo38CHRTcscvh7Kk-VTb_zWPQ4g@mail.gmail.com>
 <5669E091.1010108@turmel.org>
 <CAE9DZUTHZ0+VkAQ8ixvH9m=6XXXShDwJp6_8SeEXovW+hF6OdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUTHZ0+VkAQ8ixvH9m=6XXXShDwJp6_8SeEXovW+hF6OdQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/10/2015 04:14 PM, Dallas Clement wrote:

> Exactly.  I'm not expecting RMWs to be happening for large sequential
> writes.  But yet my RAID 5, 6 sequential write performance is still
> very poor.  As mentioned earlier, I'm getting around 95 MB/s on the
> inner side of these disks.  With 12 of them, my RAID 6 write speed
> should be (12 - 2) * 95 = 950 MB/s.  I'm getting about 300 MB/s less
> than that for this scenario.  I have the disks split up among three
> different controllers.  There should be plenty of bandwidth.  Several
> days ago I ran fio on each of the 12 disks concurrently.  I was able
> to see the disks at or near 100% utilization and wMB/s around 160-170
> MB/s.  That's why I started focusing on RAID as being the potential
> bottleneck.
> 
>> That's why I questioned O_SYNC when you were using a filesystem: it
>> prevents merging, and forces seeking to do small metadata writes.
>> Basically turning a sequential workload into a random one.
> 
> Yes, that certainly makes sense.  Not using O_SYNC anymore.  Just O_DIRECT.

Sounds like its time to break out blktrace to see what's really
happening between your array and its member devices.

With diffs from old kernels to new.

Phil
