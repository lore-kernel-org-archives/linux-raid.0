From: Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>
Subject: High System Load
Date: Wed, 28 Jul 2004 19:00:34 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A506359028CAD21191C10008C75D895C0A06C865@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm creating my first software RAID array.  I'm on a 900 MHz system with 786MB of ram, running Fedora RC1.  I'm creating a RAID 1 array consisting only of two drives, split on two IDE channels.

I used mdadm --create and everything is running fine so far, but my system load is well over 10.   Is this normal?   I suspect that this is just overhead while creating the array the first time.   Can I assume that when the array is actually put into use that the system loads will not be this high?  (I hope not!)

Thanks,

Gary H.
