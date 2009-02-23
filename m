From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Reliability of bitmapped resync
Date: Tue, 24 Feb 2009 08:18:07 +1100
Message-ID: <49A3128F.9020708@eyal.emu.id.au>
References: <20090223194019.GA3488@lazy.lzy> <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Did you mean
	echo repair > /sys/block/md0/md/sync_action

I run 'check' regularly and I am rather sure that it reports but does not fix the mismatches.

Here is my log of recent weekly 'check' runs. BTW, the mismatches are a mystery to me as
there was not one i/o error and no other event (the machine was not even powered down/up).
I will see how it does when the array moves (soon) to a new mobo.

Sat Oct 25 10:47:16 EST 2008 mdcheck: end mismatch_cnt=0
Sat Nov  1 14:49:11 EST 2008 mdcheck: end mismatch_cnt=0
Sat Nov  8 14:48:15 EST 2008 mdcheck: end mismatch_cnt=0
Sat Nov 15 14:49:13 EST 2008 mdcheck: end mismatch_cnt=0
Sat Nov 22 14:48:12 EST 2008 mdcheck: end mismatch_cnt=0
Sat Nov 29 14:48:10 EST 2008 mdcheck: end mismatch_cnt=16
Sat Dec  6 14:48:11 EST 2008 mdcheck: end mismatch_cnt=136
Sat Dec 13 14:48:10 EST 2008 mdcheck: end mismatch_cnt=184
Sat Dec 20 14:48:10 EST 2008 mdcheck: end mismatch_cnt=280
Sat Dec 27 14:48:07 EST 2008 mdcheck: end mismatch_cnt=288
Sat Jan  3 14:48:09 EST 2009 mdcheck: end mismatch_cnt=288
Sat Jan 10 14:48:09 EST 2009 mdcheck: end mismatch_cnt=328
Sat Jan 17 10:21:16 EST 2009 mdcheck: end mismatch_cnt=328
Sat Jan 24 10:17:13 EST 2009 mdcheck: end mismatch_cnt=400
Sat Jan 31 10:17:14 EST 2009 mdcheck: end mismatch_cnt=408
Mon Feb  2 17:23:14 EST 2009 mdcheck: end mismatch_cnt=408
Sat Feb  7 10:12:09 EST 2009 mdcheck: end mismatch_cnt=0 <<< after repair done manually

Eyal

NeilBrown wrote:
> On Tue, February 24, 2009 6:40 am, Piergiorgio Sartor wrote:
>> Hi all,
>>
>> I've a strange issue.
>>
>> I've a PC with 2 HDs in RAID-10 f2 with bitmap.
>> There are actually 3 md devices, boot, swap and root.
>>
>> It happens that one SATA cable is/was flaky, so sometimes,
>> at boot, /dev/sdb does not show up.
>> The RAID starts in degraded mode, tracking the writes
>> in the bitmap.
>> On the next reboot, /dev/sdb is again there, so it is
>> possible to re-add it.
>> The md device resyncs what is to be resynced, very
>> quickly, due to the bitmap.
>>
>> Later, if I run a check, usually a lot of mismatches
>> show up.
> 
> What exactly do you mean by "check".
> 
> If you mean "look in /sys/block/md0/md/mismatch_cnt", then that is
> exactly what I would expect.  The resync found some differences, just
> as you would expect it to, and reported them.
> 
> However if by "check" you mean:
>   echo check > /sys/block/md0/md/sync_action
>   mdadm --wait /dev/md0
>   cat /sys/block/md0/md/mismatch_cnt
> 
> then I would not expect any mismatches, and the resync should have
> fixed them.
> 
> If it is the later, that is a real concern and I will need to look into it.
> Please let me know exactly which kernel version and mdadm version you
> are running.
> 
> Thanks,
> NeilBrown

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
