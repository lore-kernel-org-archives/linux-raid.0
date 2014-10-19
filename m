From: Per-Ola Stenborg <per-ola@stenborg.me>
Subject: Re: Multiple drive failure after stupid mistake. Help needed
Date: Sun, 19 Oct 2014 21:00:52 +0200
Message-ID: <54440A64.9060909@stenborg.me>
References: <54438839.9080309@stenborg.me> <alpine.DEB.2.02.1410191253010.30853@uplift.swm.pp.se> <5443B55C.7000208@stenborg.me> <alpine.DEB.2.02.1410191905190.30853@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1410191905190.30853@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes! It works! Thanks so much. Lets hope the sdc drive survives the 
rebuild this time.
At least I got the opportunity to backup the 24GB important (not backed 
up data).

The Linux raid usually  works so well that you never have to worry. And 
when things go wrong
you therefor never have the experience to help fix the problem.

Thanks again!

Best regards

Per-Ola Stenborg


Mikael Abrahamsson skrev 2014-10-19 19:06:
> On Sun, 19 Oct 2014, Per-Ola Stenborg wrote:
>
>> I compiled the latest mdadm v3.3.2 - 21st August 2014
>> running
>> mdadm --assemble --force /dev/md0 /dev/sd[bcde]
>> outputs
>> mdadm: /dev/sdb is busy - skipping
>> mdadm: /dev/sdc is busy - skipping
>> mdadm: /dev/sdd is busy - skipping
>> mdadm: /dev/sde is busy - skipping
>>
>> Strange. What does this mean? Is it flaged as in use in the kernel? The
>
> Stop the array before you try to start it again.
>
> Also consider upgrading to a newer kernel if there is a backports one 
> (there should be for debian squeeze), a lot of things have happened 
> since 2.6.32.
>

