From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Mon, 22 Apr 2013 21:51:06 -0500
Message-ID: <5175F71A.8030805@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5a749bb56c88b6d6b8a806694b163bda@redhost.ro>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5a749bb56c88b6d6b8a806694b163bda@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/22/2013 5:19 AM, Andrei Banu wrote:
> Hello!
> 
> First off allow me to apologize if my rumbling sent you in a wrong
> direction and thank you for assisting.

No harm done, and you're welcome.

> The actual problem is that when I write any larger file hundreds of MB
> or more to the server (from network or from the same server) the server
> starts to overload. The server can overload to over 100 for files of ~
> 5GB. I mean this server has an average load of 0.52 (sar -q) but it can
> spike to 3 digit server loads in a few minutes from making or
> downloading a larger cPanel backup file. I have to rely only on R1Soft
> for backups right now because the normal cPanel backups make the server
> unstable when it backs up accounts over 1GB (many).

Describing this problem in terms of load average isn't very helpful.
What would be is 'perf top -U' output so we can see what is eating cpu,
simultaneously with 'iotop' so we see what's eating IO.

> So I concluded this is due to very low write speeds so I ran the 'dd'

It's most likely that the low disk throughput is a symptom of the
problem, which is lurking elsewhere awaiting discovery.

> 1. Some said the low write speed might be due to a bad cable. 

Very unlikely, but possible.  This is easy to verify.  Does dmesg show
hundreds of "hard resetting link" messages.

> 2. I have observed a very big difference between /dev/sda and /dev/sdb
> and I thought it might me indicative of a problem somewhere. If I run
> hdparm -t /dev/sda I get about 215MB/s but on /dev/sdb I get about
> 80-90MB/s. Only if I add --direct flag I get 260MB/s for /dev/sda.
> Previously when I added --direct for /dev/sdb I was getting about
> 180MB/s but now I get ~85MB/s with or without --direct.

I simply chalked up the difference to IO load variance between test runs
of hdparm.  If one SSD is always that much slower there may be a problem
with the drive or controller but it's not likely.  If you haven't
already, swap the cable on the slow drive with new one.  In fact, SATA
cables are cheap as dirt so I'd swap them both just for piece of mind.

> root [/]# hdparm -t /dev/sdb
> Timing buffered disk reads:  262 MB in  3.01 seconds =  86.92 MB/sec
> 
> root [/]# hdparm --direct -t /dev/sdb
> Timing O_DIRECT disk reads:  264 MB in  3.08 seconds =  85.74 MB/sec
...
> This is something new. /dev/sdb no longer gets to nearly 200MB/s (with
> --direct) but stays under 100MB/s in all cases. Maybe indeed it's a
> problem with the cable or with the device itself.
...
> And a 30 minutes later update: /dev/sdb returned to 90MB/s read speed
> WITHOUT --direct and 180MB/s WITH --direct. /dev/sda is constant (215
> without --direct and 260 with --direct). What do you make of this?

Show your partition tables again.  My gut instinct tells me you have a
swap partition on /dev/sdb, and/or some other partition that is not part
of the RAID1, nor equally present on /dev/sda, that is/are being
accessed heavily at some times and not others, thus the throughput
discrepancy.

If this is the case, and the kernel is low on RAM due to an application
memory leak or just normal process load, that swap partition may become
critical.  When when you start $big_file copy, the kernel goes into
overdrive swapping and/or dropping cache to make room for $big_file in
the write buffers.  This could explain both your triple digit system
load and the decreased throughput on /dev/sdb.

The fdisk output you provided previously showed only 3 partitions per
SSD, all RAID autodetect, all in md/RAID1 I assume.  However, the
symptoms you're reporting tend to suggest the partition layout I just
described, and could be responsible for the odd up/down throughput on sdb.

-- 
Stan

