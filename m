From: Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>
Subject: Growing an Array?
Date: Wed, 06 Nov 2002 09:46:11 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A506359028CAD21191C10008C75D895C040B8841@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I know exactly what I would like to do, but I'm not RAID-Smart enough to know if this is an existing capability or completely impossible.

Speaking in very generic terms, I have a RAID 5 array that is reaching it's capacity.  Drives are cheap and I want to grow the array.  Backing up the array to DLT is "hard" and I don't want to take my production system offline.   I want to buy a stack of new (hot swappable) drives and do the following to my array:

1)  pop out drive 1
2)  Insert new drive
3)  "initialize" the new drive
4)  Some magic happens and the larger drive becomes part of the array

lather, rinse, repeat for the remaining replacement drives and *poof* I have a larger array.

This capability would save me an incredible amount of labor and hand wringing.  Our "technology refresh" upgrades happen quite regularly because our data never stops growing.   Is this a pipe dream or an eventual reality?

TIA

Regards,

Gary Huntress
Code 4113
Naval Undersea Warfare Center
Newport, RI  02841
1-800-669-6892 x28990
