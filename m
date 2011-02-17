From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Wed, 16 Feb 2011 21:06:40 -0600
Message-ID: <4D5C90C0.6040607@hardwarefreak.com>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com>	<20110217124214.00ad25dd@notabene.brown>	<00E3AF11-6D18-4C5D-A165-56C86823A6D2@mac.com> <20110217131453.39444287@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217131453.39444287@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown put forth on 2/16/2011 8:14 PM:

> So your best bet it to convince xfs_repair to work with what you've got and
> try to knit together as much as it can  - which may be nothing, I really
> don't know.

xfs_repair won't help.  He's hosed.  If this had been a grow from 8
disks to 10 he'd be ok, as you grow mdadm first then XFS.  But as I
said, XFS has no shrink capability.  xfs_repair will just puke all over
itself if you run it.

> Maybe you could ask on an XFS list somewhere.

He already did, in a way, as I'm on that list.  You're more than welcome
to ask on the XFS mailing list, but you'll get the same answer.

This really sucks and I feel for Matt.  I wish he'd have asked on either
or both lists first...

What he needs to do now is start over from scratch.  Delete the current
md device and create a new one, then create a new XFS filesystem, and
then restore his files from his backup device.

Is there a Linux mdraid best practices document somewhere, that could
help prevent folks from hosing themselves like this if they'd read it first?

-- 
Stan
