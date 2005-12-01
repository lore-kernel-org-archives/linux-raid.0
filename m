From: Andrew Burgess <aab@cichlid.com>
Subject: Re: /proc/mdstat bug: 2.6.14.2
Date: Thu, 1 Dec 2005 13:59:58 -0800
Message-ID: <200512012159.jB1Lxw91015056@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Little off this topic, but how did you get the AMD64 x2 to run in single
> processor mode? I was trying to figure this out months ago.

Just boot with maxcpus=1 or make a UP kernel.

I have it working now SMP by dumping 2.6.14 and using 2.6.13.4. Nothing
but trouble with .14 including hosing half of a 3 TB raid6 array. It ran .13
for a day and then the power failed this morning and I accidently let it boot
.14 and it I started getting errors on my 3ware controllers in about an hour.
Back to 13...

Beware if you have 3ware controllers. I have a 7810, 7812 and 8506 in this
machine. They start timing out and dropping disks.

