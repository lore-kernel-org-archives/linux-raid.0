From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Tue, 15 Apr 2008 14:14:53 -0400
Message-ID: <4804F09D.5070503@tmr.com>
References: <48025B8D.2030803@harddata.com> <alpine.DEB.1.10.0804131529300.11311@p34.internal.lan> <4802AFEB.9020006@tmr.com> <4802CDA2.605@harddata.com> <4803886E.3050007@tmr.com> <4804CD4F.7080303@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4804CD4F.7080303@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maurice Hilarius wrote:
> Bill Davidsen wrote:
>> ..
>> cd /sys/block/md0/md
>> echo check >sync_action; cat mismatch_cnt
>>
> Hi Bill,
>
> I am doing this as root.
> I am seeing:
>
> [root@localhost md]# echo check >sync_action; cat mismatch_cnt
> -bash: echo: write error: Device or resource busy
> 0
>
> any suggestions?

First, did you cd to the /sys/block/mdX/md directory? And did you wait 
for the check to finish, watching /proc/mdstat?
I left that out, assumed you had read it in the man pages...

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


