From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Wed, 9 Oct 2013 10:52:28 -0300
Message-ID: <CAH3kUhFxXiv0wCjBSXenRQG-czznZdPGkzSpvnRQ85Bw+fpN+A@mail.gmail.com>
References: <20131009123135.GT1779@bitfolk.com>
	<525559D1.6030507@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <525559D1.6030507@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

just one mark
on the other thread, decent drive = enterprise level, a home level
decent drive is samsung 840 pro (if i'm not wrong), i used ocz vetex2
without problem but i don't know if it's really a good drive, but
worked in my workload...

2013/10/9 David Brown <david.brown@hesbynett.no>:
> On 09/10/13 14:31, Andy Smith wrote:
>> Hello,
>>
>> Due to increasing load of random read IOPS I am considering using 8
>> SSDs and md in my next server, instead of 8 SATA HDDs with
>> battery-backed hardware RAID. I am thinking of using Crucial m500s.
>>
>> Are there any gotchas to be aware of? I haven't much experience with
>> SSDs.
>>
>> If these were normal HDDs then (aside from small partitions for
>> /boot) I'd just RAID-10 for the main bulk of the storage. Is there
>> any reason not to do that with SSDs currently?
>>
>> I think I read somewhere that offline TRIM is only supported by md
>> for RAID-1, is that correct? If so, should I be finding a way to use
>> four pairs of RAID-1s, or does it not matter?
>>
>> Any insights appreciated.
>>
>> Cheers,
>> Andy
>
> For two hard disks, raid10 (with either f2 or o2 layout - n2 is almost
> identical to normal raid1) can be a lot faster than raid1, because you
> get the striping for big data (especially large reads), you get the
> faster read throughput because your data is on the fast outer edge of
> the disk, and your read latency is better because your head movement is
> smaller.  Your writes are a bit slower because they are scattered about
> the disk.
>
> But for two SSDs, raid10 (f2, o2) has far fewer benefits because you
> have no head movement - it is only large reads that can be faster.  If
> you need IOPS - and presumably multiple parallel accesses - this is no
> help.  raid10 has extra complexity and thus extra latency (which will
> not be noticeably with HDs, but might be with SSDs), and limitations on
> resizing and reshaping.
>
> Extrapolating to 8 disks, I think therefore 4 sets of raid1 pair is
> likely to be faster.  As to what you should do with these sets, that
> depends on the application.  XFS over a linear join might be your best
> bet - raid0 will work but you probably want a large chunk size because
> you want to avoid striped reads and writes in order to get high IOPs.
>
> Don't worry too much about TRIM if your SSDs are decent and you have
> plenty of overprovisioning, but offline TRIM is worth doing when
> supported.  (Never use online TRIM.)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
