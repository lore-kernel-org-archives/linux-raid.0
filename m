From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: Add disks to RAID5 array
Date: Thu, 22 Jul 2004 14:33:09 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002f01c4701a$5712b180$0201a8c0@windows>
References: <200407221807.i6MI7S328145@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've used raidreconf to convert from RAID 1 to RAID 5 and to grow RAID 5
arrays. I would recommend a UPS. If the power blips, the array will be lost.
Other then that, I've never had any trouble whatsoever with it. IMO,
resize2fs is more dangerous than using raidreconf. I have had resize2fs
corrupt file systems badly before. It's important to run fsck -f both before
and after resize2fs. It catches a lot of minor, fixable problems after the
resize2fs is run. Doing this, I have successfully grown RAID 5 arrays many
times without any trouble.

In any case, backing up is highly recommended if you value the data!

----- Original Message ----- 
From: "Guy" <bugzilla@watkins-home.com>
To: <robin-lists@robinbowes.com>; <linux-raid@vger.kernel.org>
Sent: Thursday, July 22, 2004 2:07 PM
Subject: RE: Add disks to RAID5 array


> A tool called Raidreconf can do what you want.
> I have never used it.
> I don't know how much risk there is in data loss.
> I would backup my data first!
>
> Find it, read about it, and understand it.
>
> Maybe someone else can comment on the risks?
>
> Guy


