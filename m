From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: RAID 1 / Power Loss / No SuperBlock
Date: Sun, 2 Feb 2003 16:08:29 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302021607270.17543-100000@router.windsormachine.com>
References: <00c301c2cafc$b9df8c80$6701a8c0@bc.hsia.telus.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00c301c2cafc$b9df8c80$6701a8c0@bc.hsia.telus.net>
To: Adam J Morand <Adam.Morand@illuminatedtechnologies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sun, 2 Feb 2003, Adam J Morand wrote:

> The error I get
> [aj@r2d2 aj]$ fsck /dev/hdd1

Why would you be modifying the /dev/hdd device?

You're lucky this isn't working, you want to do a fsck /dev/md0 or
whatever your raid1 device is numbered.

Never touch the original partitions.

Mike

