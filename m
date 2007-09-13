From: David Miller <millerdc@fusion.gat.com>
Subject: Re: RAID6 mdadm --grow bug?
Date: Thu, 13 Sep 2007 10:17:16 -0700
Message-ID: <B5D1BE90-0B04-472F-BC92-5AB446DA0C77@fusion.gat.com>
References: <42161BFD-EAE6-4485-8DE6-05D0EBE51A06@fusion.gat.com> <18153.5726.377390.171544@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18153.5726.377390.171544@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

On RHEL5 the kernel is 2.6.18-8.1.8. On Ubuntu 7.04 the kernel is  
2.6.20-16. Someone on the Arstechnica forums wrote they see the same  
thing in Debian etch running kernel 2.6.18. Below is a messages log  
from the RHEL5 system. I have only included the section for creating  
the RAID6, adding a spare and trying to grow it. There is a one line  
error when I do the "mdadm --grow" command. It is "md: couldn't  
update array info. -22."

md: bind<loop1>
md: bind<loop2>
md: bind<loop3>
md: bind<loop4>
md: md0: raid array is not clean -- starting background reconstruction
raid5: device loop4 operational as raid disk 3
raid5: device loop3 operational as raid disk 2
raid5: device loop2 operational as raid disk 1
raid5: device loop1 operational as raid disk 0
raid5: allocated 4204kB for md0
raid5: raid level 6 set md0 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
  --- rd:4 wd:4 fd:0
  disk 0, o:1, dev:loop1
  disk 1, o:1, dev:loop2
  disk 2, o:1, dev:loop3
  disk 3, o:1, dev:loop4
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than  
200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 102336 blocks.
md: md0: sync done.
RAID5 conf printout:
  --- rd:4 wd:4 fd:0
  disk 0, o:1, dev:loop1
  disk 1, o:1, dev:loop2
  disk 2, o:1, dev:loop3
  disk 3, o:1, dev:loop4
md: bind<loop5>
md: couldn't update array info. -22

David.



On Sep 13, 2007, at 3:52 AM, Neil Brown wrote:

> On Wednesday September 12, millerdc@fusion.gat.com wrote:
>>
>>
>> Problem:
>>
>> The mdadm --grow command fails when trying to add disk to a RAID6.
>>
> ..
>>
>> So far I have replicated this problem on RHEL5 and Ubuntu 7.04
>> running the latest official updates and patches. I have even tried it
>> with the most latest version of mdadm 2.6.3 under RHEL5. RHEL5 uses
>> version 2.5.4.
>
> You don't say what kernel version you are using (as I don't use RHEL5
> or Ubunutu, I don't know what 'latest' means).
>
> If it is 2.6.23-rcX, then it is a known problem that should be fixed
> in the next -rc.  If it is something else... I need details.
>
> Also, any kernel message (run 'dmesg') might be helpful.
>
> NeilBrown

