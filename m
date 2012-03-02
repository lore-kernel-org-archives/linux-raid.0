From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Fri, 2 Mar 2012 10:15:25 +0100
Message-ID: <20120302101525.4369797dab6695c34a017297@bbaw.de>
References: <4F4C9A11.9060302@profihost.ag>
	<4F4F4B1D.4050000@redhat.com>
	<4F4F4EB3.6030909@profihost.ag>
	<4F4F519E.7040206@redhat.com>
	<4F508864.4050600@profihost.ag>
	<20120302100648.fe4e725f2e98880c839357b0@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120302100648.fe4e725f2e98880c839357b0@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

I just read a previous post.
You use a GPT inside the RAID-device. But grub looks for partition tables at
a place where is none, because the partition table is inside a RAID-device.

You should use metadata version 1.0 instead of 1.2.
This metadata is place at the end of the devices like 0.90 was.
Then the partition table is at the same position as if the underlying device
was not part of a raid.

I always use metadata 1.0 for all RAID1 device.
The advantage is you always can use it like a normal disk not beeing a part
of a raid.
Also the grub doesn't need to know that it is part of a RAID.


Good luck
Lars

PS: Sorry for the empty post.
