From: joystick <joystick@shiftmail.org>
Subject: Re: want-replacement got stuck?
Date: Wed, 21 Nov 2012 23:56:23 +0100
Message-ID: <50AD5C17.6080203@shiftmail.org>
References: <20121121211910.22223.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121211910.22223.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/21/12 22:19, George Spelvin wrote:
> Here are the results from your suggestions.  The check produced something
> interesting: it halted almost instantly, rather than doing anything.
>
> # for i in /dev/sd[a-e]2 ; do echo ; mdadm -X /dev/$i ; done
>
>          Filename : /dev/sda2
>             Magic : 6d746962
>           Version : 4
>              UUID : 69952341:376cf679:a23623b9:31f68afb
>            Events : 8617657
>    Events Cleared : 8617657
>             State : OK
>         Chunksize : 2 MB
>            Daemon : 5s flush period
>        Write Mode : Normal
>         Sync Size : 725591552 (691.98 GiB 743.01 GB)
>            Bitmap : 354293 bits (chunks), 7421 dirty (2.1%)
>

Just this?
I think there should have been additional fields like "Device Role", 
"Array State", "layout"...
try with --verbose maybe?

The Events count is extremely high, I don't have it higher than 25000 on 
very active servers, I'm not sure what it means. Also one of your 
devices has a slightly lower count, and would confirm that it's failed 
(spares follow the count continuously). I don't know that MD code well, 
you might look into the driver what kind of events exactly increase the 
count.

Another test:
cat /sys/block/md5/md/degraded
returns 1 I suppose?

The fact that check returns immediately might indicate that the array is 
indeed degraded. In this case it is correct that check cannot be 
performed on a degraded array because there is no parity/mirroring to 
check/compare. The fact that for a brief instant you can see progress is 
strange though (you might have a look at the code in the driver for 
understanding that, but it's probably not so meaningful).

But the ext4 errors must come from elsewhere. The fact that they become 
apparent only after a rebuild (to sdc2) might indicate that the source 
disk (mirror of sdd, which I don't know precisely what drive is in a 
near-copies raid10) might have contained bad data, which maybe was 
previously masked by sdd which was available and reads might have gone 
preferably to sdd (the algorithm usually choses the nearest hdd head but 
who knows...). In general your disks were in a bad shape, you can tell 
that from:
 > Nov 20 11:49:06 science kernel: md/raid10:md5: sdd2: Raid device 
exceeded read_error threshold [cur 21:max 20]
I would have replaced the disk at the 2nd-3rd error maximum, you got up 
to 21. But even considering this, MD should probably have behaved anyway 
differently

My guess is that the hot-replace to sdd failed (sdd failed during 
hot-replace), but this error was not properly handled by MD (*). This is 
the first time somebody reports onto the ML a case of failure of the 
destination drive during hot-replace so there is not much experience, 
you are a pioneer.
(*) it might have erroneously failed sdc instead of failing sdd for 
example, which looks like hot-replace has succeeded but sdd wouldn't 
actually contain correct data...

For the rest I don't really know what to say, except that it doesn't 
look right. Let's hope Neil pops up.

