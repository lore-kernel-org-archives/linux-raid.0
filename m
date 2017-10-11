From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Can't mount /dev/md0 Raid5
Date: Thu, 12 Oct 2017 06:13:21 +1100
Message-ID: <e9bcdb2b-6ffe-285d-5d59-313438db61ac@websitemanagers.com.au>
References: <59DDF18A.9060800@gmail.com>
 <8628ddba-8cec-24d8-e07a-195d47f579be@grumpydevil.homelinux.org>
 <59DDFD19.1040700@gmail.com>
 <e6566c4a-2476-4554-549a-12b6c90b152f@websitemanagers.com.au>
 <59DE0705.502@gmail.com>
 <d6f39002-7120-3613-8163-7fb80b5434a1@websitemanagers.com.au>
 <59DE1E38.8080604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59DE1E38.8080604@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Joseba Ibarra <wajalotnet@gmail.com>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What is the output of cat /proc/mdstat after running the readwrite below?

Did you try the --run option?

You need to make sure the array is active/running before you try to 
mount it.

BTW, has anything else happened to the array, other than the drive that 
failed?

Probably should have asked for this before, but what is the full output 
of smartctl for each drive, also mdadm --misc --examine /dev/sd[bcd]1 
(or all three relevant devices)?

Regards,
Adam


On 12/10/17 00:35, Joseba Ibarra wrote:
> Still the same. Nothing seems to have changed.
>
>
> Same answers for mount commands.
>
> Adam Goryachev escribió:
>> mdadm --manage /dev/md0 --readwrite 
>
> Jose Ibarra
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

