From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: RAID6 simply does not start as /dev/md8
Date: Fri, 08 Apr 2011 17:22:01 +0200
Message-ID: <4D9F2819.2030403@grumpydevil.homelinux.org>
References: <4D9EC097.7010600@web.de> <20110408151751.5e2b61f1@natsu> <4D9F1962.3050806@web.de> <4D9F1A5A.1060600@grumpydevil.homelinux.org> <4D9F22A9.1030005@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D9F22A9.1030005@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Yann Ormanns <yann-ormanns@web.de>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/08/2011 04:58 PM, Yann Ormanns wrote:
> Do you have perhaps old raid metadata on the disks? Are you certain you
>> have no raid metadata on the whole disks?
>> you can check with mdadm --Examine /dev/sdc
>>
>> Cheers
>>
>>
>> Rudy
>>
>>      
> To eliminate this possibility, I "zeroed" all six disks before I created
> the array:
> dd if=/dev/zero of=/dev/sda bs=1M
> ...
> dd if=/dev/zero of=/dev/sdf bs=1M
>
> Output of mdadm -E /dev/sda1:
> 	/dev/sda1:
>    
Just to humour me, the output without the partition number? so /dev/sda ?

Cheers,


Rudy
