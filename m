From: Jonathan Molyneux <jonathan@infinitedepth.com.au>
Subject: Re: raid10 - won't rebuild - assigns all added disks as spares
Date: Tue, 25 Nov 2014 14:44:44 +1100
Message-ID: <5473FB2C.4020504@infinitedepth.com.au>
References: <5473E018.3020507@infinitedepth.com.au> <20141125132810.3b4aa867@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141125132810.3b4aa867@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks Neil,

 > echo recover > /sys/block/md1/md/sync_action

That did the trick.

Regards
Jonathan

On 25/11/2014 1:28 PM, NeilBrown wrote:
> On Tue, 25 Nov 2014 12:49:12 +1100 Jonathan Molyneux
> <jonathan@infinitedepth.com.au> wrote:
>
>> Hi Everyone,
>>
>> Have a strange situation that hasn't happened before.
>> Running Debian 7.7 with kernel version 3.2.63-2+deb7u1.
>> Have a raid10 that runs the server (boot's off a raid1) that after
>> replacing a failed disk, just won't rebuild.
>>
>> This is what it looks like without the disk (failed & removed):
>> md1 : active raid10 sda2[6] sdc2[4] sdb2[1]
>>         1952987136 blocks super 1.2 512K chunks 2 far-copies [4/3] [UUU_]
>>         bitmap: 8/15 pages [32KB], 65536KB chunk
>>
>> Then when the disk is added:
>> md1 : active raid10 sdd2[5](S) sda2[6] sdc2[4] sdb2[1]
>>         1952987136 blocks super 1.2 512K chunks 2 far-copies [4/3] [UUU_]
>>         bitmap: 8/15 pages [32KB], 65536KB chunk
>>
>> Nothing unusual is being spat out in dmesg.
>> When removing the disk:
>> [313434.073997] md: unbind<sdd2>
>> [313434.138307] md: export_rdev(sdd2)
>> When adding the disk:
>> [313468.056484] md: bind<sdd2>
>>
>> This is a strange one that I haven't had before.
>> Any thoughts on how to kick the rebuild off without needing a reboot ?
> I'm sure I've seen this bug before... and fixed it.
> I don't remember the details and cannot find anything obvious in change logs.
>
> You could try
>
>     echo recover > /sys/block/md1/md/sync_action
>
> Alternately, if you are re-adding a disk that had just been removed, you could
>
>     mdadm /dev/md1 --remove /dev/sdd2
>     mdadm --zero /dev/sdd2
>     mdadm /dev/md1 --add /dev/sdd2
>
> that will force a full recovery instead of just a bitmap-based recovery.
> That will of course take longer than a bitmap-based recover, but seeing the
> bitmap based recovery isn't starting, that could still be an improvement.
>
> NeilBrown

