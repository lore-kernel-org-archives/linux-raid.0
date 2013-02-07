From: Fredrik Lindgren <fli@wirebound.net>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 18:12:11 +0100
Message-ID: <5113E06B.7030808@wirebound.net>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <51139799.2070004@fnarfbargle.com> <51139FEE.3020807@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51139FEE.3020807@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

On 02/07/2013 01:37 PM, Adam Goryachev wrote:
> On 07/02/13 23:01, Brad Campbell wrote:
>> On 07/02/13 18:19, Adam Goryachev wrote:
>>
>>> problem. Is there some way to instruct the disk (overnight) to TRIM the
>>> extra blank space, and do whatever it needs to tidy things up? Perhaps
>>> this would help, at least first thing in the morning if it isn't enough
>>> to get through the day. Potentially I could add a 6th SSD, reduce the
>>> partition size across all of them, just so there is more blank space to
>>> get through a full day worth of writes?
>> I have 6 SSD's in a RAID10, and with 3.7.x (I forget which x - 2 or 3
>> from memory) md will pass the TRIM down to the underlying devices (at
>> least for RAID10 and from memory 1).
> Yes, I have read that the very new kernel has those patches, but I'm on
> 2.6.x at the moment, and in addition, see below why they wouldn't help
> anyway...
>
>> I have a cronjob that runs at midnight :
>> Based on the run times, and the bytes trimmed count I suspect it works.
>> All filesystems are ext4. Two of them are passed through encryption, but
>> that passes TRIM down also. I do not have the discard option on any
>> mounts (that way lies severe performance issues).
> I don't have any FS on this RAID, it is like this:
> 5 x SSD
> RAID5 (doesn't support TRIM, though I've seen some patches but I think
> they are not included in any kernel yet).
> DRBD (doubt this supports TRIM
> LVM (don't think it supports TRIM, maybe in newer kernel)
> iSCSI (don't think it support TRIM
> Windows 2003 and Windows 2000 (don't think it supports TRIM)
>
> So, really, all I want to do is use TRIM on the portion of the drive
> which is not partitioned at all, and I suspect the SSD knows that
> section is available, but how do I tell the drive "please go and do a
> cleanup now, because the users are all sleeping"?
>
> BTW, I just created a small LV (15G) and ran a couple of write tests
> (well, not proper one, but at least you get some idea how bad things are).
> dd if=/dev/zero of=/dev/vg0/testlv oflag=direct bs=16k count=50k
> ^C50695+0 records in
> 50695+0 records out
> 830586880 bytes (831 MB) copied, 99.4635 s, 8.4 MB/s
>
> I killed it after waiting a while....  this is while most of the systems
> are idle, except one which is currently being backed up (lots of reads,
> small number of writes). This is indicative of IO starvation though, I
> would have expected a significantly higher write performance?
>
> While I was running the dd, I ran a iostat -x 5 in another session:
>
> See text file attached for output, as seems to want to line wrap because
> it is too wide....
>
> dm-13 is the client (windows 2003) which is currently being backed up,
> dm-14 is the testlv I'm writing to from the localhost.

 From the iostat output it seems quite clear that the culprit is the
drbd2 device. The /dev/sd[b-f] seems to have plenty more to give,
even though they're doing some 1400 iops each (which seems a
lot for the throughput you're seeing, why are the IOs towards the
physical disks so small?).

Regarding that drbd device, Is there some mirroring being done to
another machine by way of drbd? If so, with a sync-mirror to another
machine over the network 8,4Mb/s could be quite "normal", right?

Regards,
   Fredrik Lindgren

