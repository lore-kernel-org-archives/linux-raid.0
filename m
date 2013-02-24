From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Sun, 24 Feb 2013 14:36:35 -0600
Message-ID: <512A79D3.9020502@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51272808.7070302@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/22/2013 2:10 AM, Stan Hoeppner wrote:

Revisiting this briefly...

> 2.  Run fio using this job file and post the results:
> 
> [global]
> filename=/dev/vg0/testlv (assuming this is still correct)
> zero_buffers
> numjobs=16
> thread
> group_reporting
> blocksize=256k
> ioengine=libaio
> iodepth=16
> direct=1
> size=8g
> 
> [read]
> rw=randread
> stonewall
> 
> [write]
> rw=randwrite
> stonewall

When you run the fio test above, use this for grabbing top output.  But
first, if you haven't already, run top interactively and enable per CPU
display, save by hitting 'w'.  Then use:

~$ top -b -n 60 -d 0.25|grep Cpu|sort -n > /some.dir/some.file

This will grab metrics 4 times per second instead of 2 as we did
previously.  This will give better resolution.  It will also sort the
output by CPU making it much easier to see the ramp and load trend on
each.  It should have a run time of ~16 seconds, which should be plenty
of time to launch fio and get the entire run in our top data.  I'm not
sure if we were running it long enough previously to capture (all of)
the write job.  It would probably be wise to upload the top output file
to a pastebin and link it, as it will be 240 lines long.

I'm quite anxious to see the random write results from the test above
and the accompanying CPU burn.  The bandwidth numbers should be a bit
surprising to you and others following this thread.  Ok, I'm probably
sandbagging a bit.  They should shock you.

Then, after everyone has retrieved their jaws from the floor I'll
explain why the numbers are so much higher, and why proper test
methodology is critical to benchmarking.

-- 
Stan

