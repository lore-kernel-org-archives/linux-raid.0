From: "Morgan Wahl" <morgy.wahl@gmail.com>
Subject: Re: HELP! my raid5 ate my data!
Date: Tue, 21 Oct 2008 12:40:38 -0400
Message-ID: <9512192b0810210940v77675287od420f7ea36fbf2de@mail.gmail.com>
References: <9512192b0810210915xa27061bkdc37e212f17c944b@mail.gmail.com>
	 <5d96567b0810210930r5bc4d068mef57dcfb4a237603@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0810210930r5bc4d068mef57dcfb4a237603@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

these lines are the only uncommented ones in mdadm.conf:
DEVICE /dev/sd[abcd]1
ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1

mdadm -Q /dev/md0
mdadm --examine /dev/sda1
mdadm --examine /dev/sdb1
mdadm --examine /dev/sdc1
mdadm --examine /dev/sdd1

mdadm /dev/md0 --remove /dev/sdc1

mdadm -A /dev/md0

mdadm --readonly /dev/md0

mount /dev/md0 /mnt/temp
(this return an error)
e2fsck -n /dev/md0
(lots of errors)

On Tue, Oct 21, 2008 at 12:31 PM, Raz <raziebe@gmail.com> wrote:
> Please provide the exact sequence of operations. what mdadm command
> did you use at each phase ? Did you try to mount it rw ?
>
> On Tue, Oct 21, 2008 at 6:15 PM, Morgan Wahl <morgy.wahl@gmail.com> wrote:
>> yesterday I had a problem with the SATA bus one of my drives is on,
>> which i've since fixed. I have a raid5 on four 20GB partitions (each
>> on it's own drive, of course). The one that failed was sdc1. when i
>> rebooted, the raid was no longer active (according to `mdadm -Q
>> /dev/md0`).  I ran `mdadm --examine ` on each drive. For sdc1 it said
>> everything was fine, but for the other three drives sdc1 was marked as
>> failed. I've never recovered from a drive failure before and I don't
>> think I did it correctly. I removed sdc1 from the raid and then
>> incrementally added it again. (I now realize I should've started the
>> raid with it removed and done a backup.) I started the raid again with
>> all four drives, and put it in readonly mode and tried to mount it,
>> but it presumably still isn't set up right since it refuses to mount
>> and `e2fsck -n` returns myriad errors.
>>
>> Did starting the raid with the bad disk destroy everything? did it
>> only destory a little (assuming fsck can get the filesystem back into
>> a useable state)? How can I even find out what's wrong? I do have a
>> separate terabyte disk that i've copied images of the disks to, so I
>> can perform experiment on them, but I'm not sure what to do.
>>
>> Help! Please!
>>
>>   -Morgan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
