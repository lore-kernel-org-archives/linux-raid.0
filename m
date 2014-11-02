From: micah <micah@riseup.net>
Subject: Re: Raid1 element stuck in (S) state
Date: Sun, 02 Nov 2014 10:45:50 -0500
Message-ID: <87tx2hobbl.fsf@muck.riseup.net>
References: <87k33lwq7s.fsf@muck.riseup.net> <20141029084224.6d92d8be@notabene.brown> <8761f3q8gr.fsf@muck.riseup.net> <20141030071019.1a5c57e7@notabene.brown> <87zjcepnno.fsf@muck.riseup.net> <20141030094734.2451cc24@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141030094734.2451cc24@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: micah anderson <micah@debian.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

>> >> > Are there any errors in the kernel logs when you --add the device?
>> >
>> > You didn't answer this question either.  Are there any messages in the
>> > kernel log: /var/log/kern.log on debian.
>> > Or in the output of "dmesg".
>> 
>> The only thing I see in the log is:
>> 
>> [307932.328420] mdadm: sending ioctl 1261 to a partition!
>> [307932.328425] mdadm: sending ioctl 1261 to a partition!
>> [307932.346642] mdadm: sending ioctl 1261 to a partition!
>> [307932.346648] mdadm: sending ioctl 1261 to a partition!
>> [307932.352466] mdadm: sending ioctl 1261 to a partition!
>> [307932.352468] mdadm: sending ioctl 1261 to a partition!
>> [307932.376821] mdadm: sending ioctl 1261 to a partition!
>> [307932.376824] mdadm: sending ioctl 1261 to a partition!
>> [307932.377623] mdadm: sending ioctl 1261 to a partition!
>> [307932.377630] mdadm: sending ioctl 1261 to a partition!
>> [307932.467292] md: bind<sdc1>
>> [307932.588154] RAID1 conf printout:
>> [307932.588159]  --- wd:1 rd:2
>> [307932.588164]  disk 0, wo:1, o:1, dev:sdc1
>> [307932.588167]  disk 1, wo:0, o:1, dev:sdd1
>> [307932.588248] md: recovery of RAID array md3
>> [307932.588251] md: minimum _guaranteed_  speed: 50000 KB/sec/disk.
>> [307932.588254] md: using maximum available idle IO bandwidth (but not more than 2000000 KB/sec) for recovery.
>> [307932.588260] md: using 128k window, over a total of 976759672 blocks.
>> 
>> but this is just when the device is added, after that it appears that
>> logrotation failed and I have a zero byte kern.log, and firewall spew
>> has filled up my dmesg ring.

I fixed my logging and re-added the device, and found there was a
hardware error preventing things from syncing properly. I've resolved
that error and now things are fine. Thanks for the push to look closer
there!

micah
