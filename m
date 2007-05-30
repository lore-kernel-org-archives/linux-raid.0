From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: ANNOUNCE: mdadm 2.6.2 - A tool for managing Soft RAID under
 Linux
Date: Wed, 30 May 2007 06:23:51 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0705300621160.31301@praktifix.dwd.de>
References: <18001.9765.808761.531809@notabene.brown>
 <200705291829.54274.thomas.jarosch@intra2net.com> <18012.37348.161496.473678@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18012.37348.161496.473678@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 30 May 2007, Neil Brown wrote:

> On Tuesday May 29, thomas.jarosch@intra2net.com wrote:
>> Hello Neil,
>>
>> On Monday, 21. May 2007, you wrote:
>>> I am pleased to announce the availability of
>>>    mdadm version 2.6.2
>>
>> Thanks for releasing mdadm 2.6.2. It contains a fix for "--test"
>> I was looking for right at the moment :-)
>>
>> mdadm fails to compile if you enable "-O2" using gcc 4.1.1 because of -Werror:
>>
>> cc1: warnings being treated as errors
>> sysfs.c: In function 'sysfs_read':
>> sysfs.c:97: warning: value computed is not used
>> sysfs.c:119: warning: value computed is not used
>> sysfs.c:127: warning: value computed is not used
>> sysfs.c:133: warning: value computed is not used
>> sysfs.c:139: warning: value computed is not used
>> sysfs.c:178: warning: value computed is not used
>
> Those are bogus warnings. Each is
> 	strcpy(base, "xxxxx");
> and base most certainly is used., though I can see how gcc might not
> notice if it is being too clever. Maybe you need to get gcc-4.1.2?
> or
>   make CWFLAGS=-Wall
>
Maybe the compiler warns about the return of strcpy() not being used.
The correct fix would then be:

        (void)strcpy(base, "xxxxx");

Holger

