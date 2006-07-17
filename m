From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Array will not assemble
Date: Mon, 17 Jul 2006 14:22:07 -0400
Message-ID: <44BBD54F.7080507@tmr.com>
References: <44AD9F2B.9090205@sauce.co.nz> <17581.42401.473236.453490@cse.unsw.edu.au> <44ADBC13.9010500@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44ADBC13.9010500@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie wrote:

> Neil Brown wrote:
>
>> Add
>>   DEVICE /dev/sd?
>> or similar on a separate line.
>> Remove
>>   devices=/dev/sdc,/dev/sdd
>
>
> Thanks.
>
> My mistake, I thought after having assembled the arrays initially, 
> that the output of:
>
>  mdadm --detail --scan > mdadm.conf
>
> could be used directly.
>
> I'm using Centos 4.3, which I believe is the latest RHEL 4 and they 
> are only on mdadm 1.6  :( 


Do understand that the whole purpose of RHEL is to have a stable system. 
Upgrades are not done, instead bugs are fixed in the original version to 
correct security or stability issues. However, feature changes are not 
provided, because ver versions mean new issues. Stability has its price.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

