From: Andrej <andrej@rikom.si>
Subject: RAID-1 on RedHat 7.3 (resize problems)
Date: Fri, 24 Jan 2003 17:32:53 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0301241727400.24381-100000@www.sk-branik.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I have been trying to setup raid 1 on an Redhat 7.3 box. I
have used the "Software Raid HOWTO"
(http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html).
In setting up the raid I have booted using rescue mode and tried to follow
the 13 steps in the howto but get stuck on one of the last steps. The
final step tells me I should have all md based filesytems unmounted except
root which is remount as read-only. When I try to resize the partion using
resize2fs /dev/md0 it complains that it is mounted. I can not unmount it
as it is in use (as read-only). Should the resize command work with the
partion as read-only as the howto suggests?
How else do I complete this step?

I have two identical disks (hda,hdc) and the following setup :
md0(hda1,hdc1) /boot
md1(hda2,hdc2) /
md2(hda3,hdc3) SWAP

Thanks for your help and have a nice day,

	Andrej.

