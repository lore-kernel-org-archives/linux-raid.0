From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: LVM on raid10,f2 performance issues
Date: Mon, 26 Jan 2009 14:06:03 -0500
Message-ID: <497E099B.5060805@tmr.com>
References: <49332920.5010503@gmail.com> <20081201164244.GB23899@rap.rap.dk> <4935C4B3.2060404@gmail.com> <493654C7.2090909@ziu.info> <8CB47EBD70FE9E8-AC4-981@WEBMAIL-DG06.sim.aol.com> <49742B94.8090407@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49742B94.8090407@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: thomas62186218@aol.com, soltys@ziu.info, mauermann@gmail.com, keld@dkuug.dk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> thomas62186218@aol.com wrote:
>   
>> Hi everyone,
>>
>> I too was seeing miserable read-performance with LVM2 volumes on top of
>> md RAID 10's on my Ubuntu 8.04 64-bit machine. My RAID 10 has 12 x 300GB
>> 15K SAS drives on a 4-port LSI PCIe SAS controller.
>>
>> I use:
>> blockdev --setra 65536 /dev/md0
>>
>> And this dramatically increased my RAID 10 read performance.
>>
>> You MUST do the same for your LVM2 volumes for them to see a comparable
>> performance boost.
>>
>> blockdev --setra 65536 /dev/mapper/raid10-testvol
>>
>>     
>
> This is incorrect. Only the readahead setting of the _last_ block device
> matters. So in case you have a raid6 of 10 drives, with LUKS on top,
> with LVM on top - only the readahead settings of the individual LVs
> matter, nothing further down the chain is consulted.

I have some old numbers which indicate that with ext3 the use of 
"stride=" can improve performance, although I was measuring write and 
just got the read numbers without really caring about them.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


