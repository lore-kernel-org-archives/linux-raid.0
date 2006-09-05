From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID over Firewire
Date: Tue, 05 Sep 2006 09:56:23 -0400
Message-ID: <44FD8207.2030502@tmr.com>
References: <44EB94BE.8080907@sauce.co.nz> <44FC653D.8020600@tmr.com> <44FC830D.2020007@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FC830D.2020007@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie wrote:

> Bill Davidsen wrote:
>
>>
>> It should work, but I don't like it... it leaves you with a lot of 
>> exposure between backups.
>>
>> Unless your data change a lot, you might consider a good incremental 
>> dump program to DVD or similar.
>
>
> Thanks. I have abandoned this option for various reasons, including 
> people randomly unplugging the drives.
>
> Rsync to another machine is the current plan. 

At one time I was evaluating doing RAID1 to an NBD on another machine, 
using write-mostly to make it a one way process. I had to redeplot the 
hardware before I reached a conclusion, and it was with an older kernel, 
so I simply throw it out for discussion.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

