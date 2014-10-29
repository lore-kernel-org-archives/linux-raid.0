From: micah <micah@riseup.net>
Subject: Re: Raid1 element stuck in (S) state
Date: Wed, 29 Oct 2014 17:32:43 -0400
Message-ID: <87zjcepnno.fsf@muck.riseup.net>
References: <87k33lwq7s.fsf@muck.riseup.net> <20141029084224.6d92d8be@notabene.brown> <8761f3q8gr.fsf@muck.riseup.net> <20141030071019.1a5c57e7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141030071019.1a5c57e7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: micah anderson <micah@debian.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> On Wed, 29 Oct 2014 10:03:16 -0400 micah <micah@riseup.net> wrote:
>
>> NeilBrown <neilb@suse.de> writes:
>> 
>> > On Mon, 27 Oct 2014 10:18:47 -0400 micah anderson <micah@debian.org> wrote:
>> >
>> >> 
>> >> Hi,
>> >> 
>> >> i've got a raid1 setup, where one drive died, it was replaced with a new
>> >> one, but its stuck in a (S) state and I can't seem to get it added into
>> >> the array, /proc/mdstat looks like this:
>> >> 
>> >> md3 : active raid1 sdc1[2](S) sdd1[1]
>> >>       976759672 blocks super 1.2 [2/1] [_U]
>> >> 
>> >> where sdc1 is the replaced drive.
>> >> 
>> >> What is the right way to get this added back?
>> >>
>> >
>> > I've a feeling this bug might have been fixed.
>> > What versions of mdadm and Linux are you using?
>> 
>> I'm using squeeze here, and had 3.1.4-1+8efb9d1+squeeze1 installed, I
>> just installed the backport, which is 3.2.5-3~bpo60+1.
>
> Is assume that is the version of mdadm.  You didn't say what version of Linux.

Yes, that is the version of mdadm. I am running squeeze, which is a
2.6.32-5 version of the kernel, and it is an amd64 machine.

>> > Are there any errors in the kernel logs when you --add the device?
>
> You didn't answer this question either.  Are there any messages in the
> kernel log: /var/log/kern.log on debian.
> Or in the output of "dmesg".

The only thing I see in the log is:

[307932.328420] mdadm: sending ioctl 1261 to a partition!
[307932.328425] mdadm: sending ioctl 1261 to a partition!
[307932.346642] mdadm: sending ioctl 1261 to a partition!
[307932.346648] mdadm: sending ioctl 1261 to a partition!
[307932.352466] mdadm: sending ioctl 1261 to a partition!
[307932.352468] mdadm: sending ioctl 1261 to a partition!
[307932.376821] mdadm: sending ioctl 1261 to a partition!
[307932.376824] mdadm: sending ioctl 1261 to a partition!
[307932.377623] mdadm: sending ioctl 1261 to a partition!
[307932.377630] mdadm: sending ioctl 1261 to a partition!
[307932.467292] md: bind<sdc1>
[307932.588154] RAID1 conf printout:
[307932.588159]  --- wd:1 rd:2
[307932.588164]  disk 0, wo:1, o:1, dev:sdc1
[307932.588167]  disk 1, wo:0, o:1, dev:sdd1
[307932.588248] md: recovery of RAID array md3
[307932.588251] md: minimum _guaranteed_  speed: 50000 KB/sec/disk.
[307932.588254] md: using maximum available idle IO bandwidth (but not more than 2000000 KB/sec) for recovery.
[307932.588260] md: using 128k window, over a total of 976759672 blocks.

but this is just when the device is added, after that it appears that
logrotation failed and I have a zero byte kern.log, and firewall spew
has filled up my dmesg ring.

>> Can I just zero the superblock of that device and re-add it in order to
>> resolve this?
>
>
> If it resyncs and the is still spare, there was almost certainly some sort of
> failure.  There really must be something in the kernel logs at that time.

It did resync, and is still a spare.... Now that I've fixed the logs,
I'm going to try it again to see if there is any error that happens
after the sync finishes.

micah
