From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid5 Construction Question
Date: Thu, 19 Aug 2004 16:53:17 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408192053.i7JKrH314329@watkins-home.com>
References: <200408192224.06572.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408192224.06572.maarten@ultratux.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To do the read test as Maarten suggests, do this:
time dd if=/dev/sdc of=/dev/null bs=64k
Where <sdc> is the name of the disk to test.
Test them all.
Test them at the same time if you want, use different windows so the output
does not get mixed together.
Larger block sizes are fine.
"time" is only added to compare the performance of the disks.

The above is a re-only test.  So, it is safe.

"sdc" is the whole disk!  If you try a write test it will trash the
partition table and all data.

I have a cron job that tests all of my disks each night.
Bad sectors really f up raid 5 arrays.
Odd, since I started testing each night, I have never had anymore bad
sectors.  Not that I recall.  Maybe somehow it helps.  Maybe sectors that
require re-tries or error correction to read are re-located before they go
completely bad.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Maarten van den Berg
Sent: Thursday, August 19, 2004 4:24 PM
To: linux-raid@vger.kernel.org
Subject: Re: Raid5 Construction Question

On Thursday 19 August 2004 19:52, PAulN wrote:
> Guy,
> thanks for the snappy reply!  I wish my disks were as fast :)
> I failed to mention that I had been tweaking those proc values.  Currently
> they are:
> (root@lcn0:raid)# cat speed_limit_max
> 200000
> (root@lcn0:raid)# cat speed_limit_min
> 10000
>
> If I'm correct, this means that the min speed is 10MB/sec per device.
> I've verified that each device has a seq write speed of about 38MB/sec so
> each should be capable of handling 10,000Kbytes sec.  Right after I issue
> a raidstart the speed is pretty good (~30MB/sec) but is just falls until
> it hits
> around 300K.
>
> md0 : active raid5 sdh1[7] sdf1[6] sdg1[5] sde1[4] sdd1[3] sdc1[2]
> sdb1[1] sda1[0]
>       481949184 blocks level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
>       [>....................]  resync =  2.4% (1936280/80324864)
> finish=4261.4min speed=305K/sec

Something like this happened to me a while ago.  The speed is good at start,

then after a certain amount of time starts degrading until very very low, 
like 5k/sec.  It keeps ever decreasing. Also, the decrease of speed occurred

at exactly the same point every time.  After a lot of searching, asking and 
bitching the true reason was revealed; one of the disks had problems and 
couldn't read/write a part of its surface.  Only when I ran dd on it (and
saw 
the read errors reported) did I realize that.

So if what you are seeing is this ever-decreasing speed, starting at a 
specific point, I'd strongly concur with Guy in saying: Test each disk 
separately by reading /and or writing its _entire_ surface using the dd 
commands suggested. Not using hdparm or benchmarks, but reading the entire 
disk(s) as described.  The purpose of this is NOT that you get an idea of
the 
speed, but that you verify that the entire surface is still ok.

Beyond that, I have no suggestions to offer you.

Maarten

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

