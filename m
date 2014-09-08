From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_RAID0_size_over_2_TB?=
Date: Mon, 08 Sep 2014 09:24:50 +0200
Message-ID: <20140908092450.8E735FB7@pobox.sk>
References: <20140906230928.BB645CEE@pobox.sk>, <20140908170037.451e2376@notabene.brown>, <20140908091811.1DD1140C@pobox.sk> <alpine.DEB.2.02.1409080920510.14735@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1409080920510.14735@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> CC: linux-raid@vger.kernel.org
>On Mon, 8 Sep 2014, azurIt wrote:
>
>> I, of course, didn't use fdisk to create partitions - they were created using cgdisk, but it's graphical tool so i wasn't able to send output from it, so i get output from fdisk to prove, that partitions are large enough.
>>
>> # cat /proc/partitions
>> major minor  #blocks  name
>>
>>   8       33 2147483647 sdc1
>>   8       49 2147483647 sdd1
>
>.... they're not.
>
>-- 
>Mikael Abrahamsson    email: swmike@swm.pp.se




so why cgdisk and also fdisk sees them as 4TB?
