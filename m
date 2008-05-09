From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Booting off of RAID10 versus RAID1
Date: Fri, 09 May 2008 11:09:44 -0400
Message-ID: <48246938.3070909@tmr.com>
References: <48230154.4000509@harddata.com> <48231C82.9010509@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48231C82.9010509@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Maurice Hilarius wrote:
>   
>> After recent issues discovered with RAID1 and failing disks, I am
>> contemplating alternatives to ensure more reliability.
>>
>> The question that arises: Is there any way to boot a system from a
>> RAID10 md?
>>     
>
> I've been wondering about booting grub/initrd from a flash USB stick (industrial
> quality if needed).
>   

Not needed, you won't be writing it often (I hope!), so just the MBR and 
/boot can go on that device.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


