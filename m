From: linuxraid@valli.org
Subject: Re: 2010S issues
Date: Wed, 14 Jan 2004 19:30:53 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <27418.194.153.176.133.1074105053.squirrel@mail.valli.org>
References: <400518E8.1060409@xs4all.nl>
     <36903.194.153.178.110.1074084208.squirrel@mail.valli.org>
     <20040114175552.GG1594@srv-lnx2600.matchmail.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040114175552.GG1594@srv-lnx2600.matchmail.com>
To: Mike Fedyk <mfedyk@matchmail.com>
Cc: Jasper Slits  <slits@xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Mike,
The 2010s is a hardware RAID solution. It has nothing todo
with 'MD raid' which is a software RAID solution.
I didn't build the MD raid things, neither as modules nor
compiled in static in the kernel.

Valli

> On Wed, Jan 14, 2004 at 01:43:28PM +0100, linuxraid@valli.org wrote:
>> FINISH
>> - try to reboot
>>   unfortunatelly we can only boot from the bootdisk
>>   booting from the RAID doesn't work
>
> That's because the MD raid is built as modules.
>
> I never took the time to work with raid modules since it won't autodetect
> (it's compiled out for the modules case), you have to have some code in
> userspace put them back together (try mdadm).
>

