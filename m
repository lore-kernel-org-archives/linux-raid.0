From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Fri, 29 Jan 2010 20:14:25 +0100
Message-ID: <4B633391.3020905@texsoft.it>
References: <4B5F6C73.30707@texsoft.it>	<20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129214852.00e565c4@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Goswin von Brederlow <goswin-v-b@web.de>
List-Id: linux-raid.ids

Neil Brown wrote:
> If a device is generating lots of read errors, we really should do something
> proactive about that.
> If there is a hot spare, then building onto that while keeping the original
> active (yes, still on the todo list) would be a good thing to do.
>
> v1.x metadata allows the number of corrected errors to be recorded across
> restarts so a real long-term value can be used as a trigger.
>
> So there certainly are useful improvements that could be made here.
>   

It's exactly my opinion.
To use a hot spare if available seems to me a very good idea.
About the metedata version, I was quite disappointed to see that the 
default when creating the array is still the 0.9 (correct me if newer 
distros behave differently), which does not persist info about the 
corrected read errors.
Into a previous post I suggested to let at least the admins to be 
conscious of the sistuation:

> - it seems that the max number of read errors allowed is set 
> statically into raid5.c by "conf->max_nr_stripes = NR_STRIPES;" to 
> 256, eventually let it be configurable by an entry into /sys/block/mdXX
> - let /proc/mdstat report clearly how many read errors occurred per 
> device, if any
> - let mdadm be configurable in monitor mode to trigger alerts when the 
> number of read errors for a device changes or goes > n
> - explain clearly in the how-to and other user's documentation what's 
> the behaviour of the raid towards read errors; after a fast survey 
> among my colleagues, i have noticed nobody was aware of this, and all 
> of them were sure that raid had the same behaviour for both write and 
> read errors!
I wrote a little patch (just 2 lines of code) for drivers/md/md.c in 
order to let /proc/mdstat report if a device has read errors, and how many.
So my /proc/mdstat now shows something like:

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
[raid1] [raid10]
md0 : active raid5 sda1[0] sdb1[1](R:36) sdc1[2]
     4192768 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

where /dev/sdb1 has 36 corrected read errors.
This lets me know at a glace the real health status of my array.
As every info needed is available throught 
/sys/block/mdXX/md/rdXX/errors, i think it would be not difficult to 
manage to implement some monitor as standalone application or into mdadm.

One thing is clear to me, now that I faced a disaster over a 6 disks 
raid5 array: it's a *big* *hazard* to have devices which gave read 
errors into an array, without having md at least signaling the situation 
(throught /proc/mdstat or mdadm or anything else). Resync in case of 
another disk failure is likely to fail.

I think it's also a mess for the image of the whole linux server 
community: try to explain to a customer that his robust raid system, 
with 6 disks plus 2 hot spares, just died because there were read 
errors, which were well kwnown by the system; and that now all his 
valuable data are lost!!! That customer may say "What a server...!!!", 
kill you, then get a win server by sure!!

Someone may argue that the health status of disk should be monitored by 
smart monitors... but I disagree, imho md driver must not rely on 
external tools, it already has info on read errors and should manage 
them to avoid as much risk as possible by itself. Smart monitoring is 
surely useful... if installed, supported by hardware, properly 
configured... but md should not assume that.

Thanks for your interest.

-- 
Yours faithfully.

Giovanni Tessore

