From: Jason Lunz <lunz@falooley.org>
Subject: Re: recovery of hosed raid5 array
Date: Sun, 12 Oct 2003 15:14:39 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <slrnboirt8.me8.lunz@orr.homenet>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linux-raid@ied.com said:
> Can you please share with us newbies why using "smartctl" in such
> situation is foolish, so we don't make the same mistake ?

SMART is a way to determine the health of hard disks, and smartctl is
part of the smartmontools suite that is used under linux to assess the
SMART status of disks.

What was foolish was me provoking /dev/hde by asking it to report
diagnostics with smartctl at the same time the array was rebuilding
/dev/hdg. Even if something _was_ wrong with hde, it wouldn't have
helped me to find out then during the rebuild. Had the resync completed,
I'd have all my data now and one dead disk.

The question remains: What's the best way to get at the mostly unharmed
data on hdg from before the rebuild started? I know it's there.

Jason

