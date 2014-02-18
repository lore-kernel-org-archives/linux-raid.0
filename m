From: Bill <billstuff2001@sbcglobal.net>
Subject: Re: raid5 replace ignored error?
Date: Tue, 18 Feb 2014 13:16:14 -0600
Message-ID: <5303B17E.5010708@sbcglobal.net>
References: <52F0AC42.5080407@sbcglobal.net> <20140218144657.28b7601e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140218144657.28b7601e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/17/2014 09:46 PM, NeilBrown wrote:
> On Tue, 04 Feb 2014 03:00:50 -0600 Bill <billstuff2001@sbcglobal.net> wrote:
>
>> Hi,
>>
>> I had something weird happen during a replace in a raid5 array on kernel
>> 3.10.28 -
>> it appears an error in writing to / communicating with the replacement
>> disk was ignored.
>>
>> I have this array:
>>
>> md3 : active raid5 sda1[0] sdd1[3] sdb1[1] sdf1[4] sdc1[2]
>>         3900742144 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
>>         bitmap: 0/233 pages [0KB], 2048KB chunk
>>
>> I tried replacing sdf1 with sde1.
>>
>>       [106666.129833] md: recovery of RAID array md3
>>       [106666.129836] md: minimum _guaranteed_  speed: 20000 KB/sec/disk.
>>       [106666.129837] md: using maximum available idle IO bandwidth (but
>> not more than 200000 KB/sec) for recovery.
>>       [106666.129842] md: using 128k window, over a total of 975185536k.
>>
>> 1/2 hour later I got a flood of errors in dmesg:
>>
>>       [108334.974861] ata5.00: exception Emask 0x10 SAct 0x7fffffff SErr
>> 0x480100 action 0x6 frozen
>>       [108334.974864] ata5.00: irq_stat 0x08000000, interface fatal error
>>       [108334.974866] ata5: SError: { UnrecovData 10B8B Handshk }
>>       [108334.974868] ata5.00: failed command: WRITE FPDMA QUEUED
>>       [108334.974872] ata5.00: cmd 61/00:00:10:97:9e/04:00:15:00:00/40
>> tag 0 ncq 524288 out
>>       [108334.974872]          res 40/00:b0:10:f7:9e/00:00:15:00:00/40
>> Emask 0x10 (ATA bus error)
>>       [108334.974873] ata5.00: status: { DRDY }
>>       .
>>       .(29 more of the same message)
>>       .
>>       [108344.976877] ata5: softreset failed (1st FIS failed)
>>       [108344.976883] ata5: hard resetting link
>>       [108349.874854] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>       [108349.901025] ata5.00: configured for UDMA/133
>>       [108349.901055] ata5: EH complete
>>
>> There were no md error messages, the recovery continued, and finished a
>> few hours later.
>>
>>       [122443.805899] md: md3: recovery done.
>>
>>
>> Afterwards I did a QC check and found a mismatch in one file which I
>> mapped to the area
>> being updated when this error was logged.
>>
>> What should happen in this case?
>> Should the "replace" have failed or is there something else going on here?
> Hi Bill,
>   sorry for the delay.
>
> Were there any message like:
>     end_request: I/O error, dev sde, sector NNNNNNNN
>
> ??
> If not, then the error never got up to md - the driver thinks that it managed
> to recovery.
> If so, then md really should have marked the replacement as faulty - or
> possible recorded a bad-block if the device has a badblock log on it (mdadm
> -E would tell you).
>
> If the write actually failed, but md wasn't told, then that is a problem in
> the driver or device.
> If the md was told, then it certainly would be a bug in md.
>

Thanks for the help, Neil

There were no "I/O error" messages, and the drive is healthy according 
to SMART data.

I later found that these errors came after I hot-plugged a drive into a 
different sata
card. During the hotplug for the new disk, the controller for sde 
hard-reset, then
I got the flood of errors above, then it hard-reset again 10 seconds 
later and things
worked ok from there.

When I dug into the file which got corrupted, I found blocks of zero bytes,
which implies the write didn't happen because I had zero'd the drive 
before doing
the replace. So it seems like something failed and md didn't hear about it.

This happened while I was breaking in a new system, and I've since 
tightened up
some loose screws and loose cables, and things are much more stable now.

Thanks again,
Bill










