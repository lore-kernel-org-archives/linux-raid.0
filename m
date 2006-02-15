From: Mirko Benz <mirko.benz@web.de>
Subject: Re: NVRAM support
Date: Wed, 15 Feb 2006 09:24:06 +0100
Message-ID: <43F2E526.9010409@web.de>
References: <43EC5655.1060504@web.de> <20060210124204.GC28676@harddisk-recovery.com> <43ECB4A4.6010005@tmr.com> <Pine.LNX.4.64.0602101700540.30925@twinlark.arctic.org> <20060213092204.GB3209@harddisk-recovery.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060213092204.GB3209@harddisk-recovery.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: dean gaudet <dean@arctic.org>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My intention was not to use a NVRAM device for swap.

Enterprise storage systems use NVRAM for better data protection/faster=20
recovery in case of a crash.
Modern CPUs can do RAID calculation very fast. But Linux RAID is=20
vulnerable when a crash during a write operation occurs.
E.g. Data and parity write requests are issued in parallel but only one=
=20
finishes. This will
lead to inconsistent data. It will be undetected and can not be=20
repaired. Right?

How can journaling be implemented within linux-raid?

I have seen a paper that tries this in cooperation with a file system:
=84Journal-guided Resynchronization for Software RAID=93
www.cs.wisc.edu/adsl/Publications

But I would rather see a solution within md so that other file systems=20
or LVM can be used on top of md.

Regards,
Mirko

Erik Mouw schrieb:
> On Fri, Feb 10, 2006 at 05:02:02PM -0800, dean gaudet wrote:
>  =20
>> On Fri, 10 Feb 2006, Bill Davidsen wrote:
>>    =20
>>> Erik Mouw wrote:
>>>      =20
>>>> You could use it for an external journal, or you could use it as a=
 swap
>>>> device.
>>>> =20
>>>>        =20
>>> Let me concur, I used external journal on SSD a decade ago with jfs=
 (AIX). If
>>> you do a lot of operations which generate journal entries, file cre=
ate,
>>> delete, etc, then it will double your performance in some cases. Ot=
herwise it
>>> really doesn't help much, use as a swap device might be more helpfu=
l depending
>>> on your config.
>>>      =20
>> it doesn't seem to make any sense at all to use a non-volatile exter=
nal=20
>> memory for swap... swap has no purpose past a power outage.
>>    =20
>
> No, but it is a very fast swap device. Much faster than a hard drive.
>
>
> Erik
>
>  =20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
