From: "Martin Clauss" <mc@openskynet.de>
Subject: RE: Problems with SCSI devices renaming...
Date: Tue, 19 Oct 2004 19:35:00 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <LGEHJKEJFBMMDCIAJCDCEEAOCCAA.mc@openskynet.de>
References: <20041019150222.GD30951@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041019150222.GD30951@percy.comedia.it>
To: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> forget autodetect,
> forget raidtools,
> switch to mdadm.

Yep, seems a bit smarter, and I discovered that there were multiple superblocks
on some of the disks (from former usage i guess), which confused mdrun....
Now I hope that it can handle changed device names, I'll try tomorrow...

Thanks,
Martin

