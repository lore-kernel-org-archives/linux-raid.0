From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Stuck reshape
Date: Sun, 24 Nov 2013 19:44:10 -0600
Message-ID: <5292AB6A.4010605@nuclearwinter.com>
References: <528FADE0.4090608@nuclearwinter.com> <20131125104316.09a98169@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131125104316.09a98169@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/24/2013 5:43 PM, NeilBrown wrote:
>> I initiated the re-shape with the following command (devices 4->5, level
>> 5->6, chunk 512->256):
>> mdadm --grow /dev/md1 --level=6 --raid-devices=6 --chunk=256
>
> So devices: 4 -> 6 ??

Correct, devices 4->6.

>
>>
>> The output was:
>> mdadm: level of /dev/md1 changed to raid6
>> mdadm: Need to backup 3072K of critical section..
>>
>> The status is:
>>
>> md1 : active raid6 sdo1[6] sdn1[5] sdd1[2] sdb1[4] sdc1[0] sda1[1]
>>       2929890816 blocks super 1.2 level 6, 512k chunk, algorithm 18
>> [6/5] [UUUU_U]
>>       [>....................]  reshape =  0.0% (512/976630272)
>> finish=56199369.9min speed=0K/sec
>>       bitmap: 0/1 pages [0KB], 1048576KB chunk
>>
>> This process is chewing up a lot of CPU:
>>  2858 root      20   0    7936   3692    280 R  91.5  0.0  35:23.72 mdadm
>>  2856 root      20   0       0      0      0 R  24.4  0.0  14:05.14
>> md1_raid6
>>  2857 root      20   0       0      0      0 R  12.2  0.0   4:28.68
>> md1_reshape
>>
>> (that's 91.5% for mdadm, 24.4% for md1_raid6, and 12.2% for md1_reshape)
>>
>> All drives are on-line and functioning normally. I did forget to remove
>> the internal bitmap and I also forgot to use an external backup file.
>
> You don't need a backup file when increasing the number of data
drives, and
> recent kernels don't need you to remove the bitmap (and one those that
did,
> it would fail cleanly).
> So these aren't problems.
>
> Still, something is clearly wrong.
>
> It should be completely safe to reboot ... but given that I don't know
what
> the reshape is hanging here I cannot promise that the reshape won't hang
> again after a reboot.
>
> I'll try to reproduce this and see if I can understand what is happening.
> Meanwhile ... maybe try killing mdadm.  That certainly won't hurt and may
> help.
>
> NeilBrown
>

Thank you for your reply. I managed to resolve this issue but hadn't
gotten around to replying with an update.

I noticed, via strace, that mdadm was reading from sysfs as fast as it
could and was trying to open sync_completed O_RDWR which it was unable
to do since it was read-only. Just for fun I changed sync_completed to
0644 and all mdadm did with that file was read from it. This was with
mdadm v3.2.6. This 'fix' did not change any aspect of the behavior other
than allowing mdadm to read the file w/o error.

I finally decided to 'echo max > /sys/block/md1/md/sync_max'. It had
been stuck at 1024. That unstuck the reshape and it completed
successfully. Being paranoid, I did a full compare of the most recent
backup and no (unexpected) differences were detected.

I did a 'echo t > /proc/sysrq-trigger' while things were stuck but it
overran the buffer rather badly.

--Larkin

