From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid6 write performance
Date: Mon, 26 Jan 2009 13:47:05 -0500
Message-ID: <497E0529.3050501@tmr.com>
References: <49742E74.9090502@rabbit.us>	 <8CB482475EFC01A-17F0-256E@webmail-dx12.sysops.aol.com> <1cd4f41f0901190107l53d02785l844da71a6643605@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1cd4f41f0901190107l53d02785l844da71a6643605@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NiftyFedora Mitch <niftyfedora@niftyegg.com>
Cc: thomas62186218@aol.com, rabbit+list@rabbit.us, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NiftyFedora Mitch wrote:
> On Mon, Jan 19, 2009 at 12:10 AM,  <thomas62186218@aol.com> wrote:
>   
>> I tested RAID 5 and RAID 6 with 12 x 15K SAS drives on Ubuntu 8.04 64-bit
>> and found their performance to be about the same. I used 256 K chunk size,
>> v1.0 superblocks, stripecachesize of 16384, and readahead of 65536.
>>
>> RAID 5 reads: 774 MB/sec
>> RAID 5 writes: 585 MB/sec
>>
>> RAID 6 reads: 742 MB/sec
>> RAID 6 writes: 559 MB/sec
>>
>> My CPU utilization remains under 10% though during writes, and I'm wondering
>> what can be done to get write performance closer to read performance. I have
>> dual quad-core CPUs so there's plenty of CPU to go around. Any ideas on that
>> front?
>>
>> -Thomas
>>
>>
>> -----Original Message-----
>> From: Peter Rabbitson <rabbit+list@rabbit.us>
>> To: linux-raid@vger.kernel.org
>> Sent: Sun, 18 Jan 2009 11:40 pm
>> Subject: Raid6 write performance
>>     
>
>   
>> Hi,
>>
>> I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I am
>> having is that no matter what chunk size I use, the write benchmark
>> always comes out at single drive speed, although I should be seeing
>> double drive speed (read speed is at near 4x as expected). Is there some
>> hidden setting that I am overlooking, or is this a current known
>> limitation of raid6? In contrast if I make a raid5 on these 4 drives, I
>> get the expected 3xdrive write speed, and occasionally 4xdrive linear
>> read speed.
>>
>> When the write test is running, I get about 14% of system cpu a sporadic
>> 40% of iowait and the rest idle at all times (machine is in runlevel 1
>> so not to screw with results). Anyone has any ideas?
>>     
>
> Read bandwidth will always be quicker than writes with parity.
> Data and parity both need to be written in an atomic way so the completion
> will be gated by the last write to be "posted as done" back to the
> system.
>
> It can pay to locate the journal  on a physically different, smaller
> and faster resource.
> One informative experiment might be to mount the file system as ext2 and compare
> and contrast with the same FS mounted as ext3.  I am not recommending ext2
> over ext3 other than as an experiment to see what the impact of the
> journal activity is...
>
>   
Also see noatime, relatime, etc.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


