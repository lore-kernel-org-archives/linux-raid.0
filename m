From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid Level Migration and Online Capacity Expansion
Date: Thu, 22 Dec 2005 09:07:25 -0800
Message-ID: <200512221707.jBMH7PCS028943@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>	3) Performance issues:  I'm currently thinking of
>using either RAID 10 or LVM2 with RAID 5 to serve as a
>RAID server.

I think you always want LVM2 between raid and the filesystem. Not only can you
expand things but you can discard older raid arrays when you upgrade. At least
you should study the docs for LVM to see if it would be good for your
application.

