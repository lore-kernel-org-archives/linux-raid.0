From: mark delfman <markdelfman@googlemail.com>
Subject: single cpu thread performance limit?
Date: Thu, 11 Aug 2011 16:58:48 +0100
Message-ID: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

I seem to have hit a significant hard stop in MD RAID1/10 performance
which seems to be linked to a single CPU thread.

I am using extremely high speed (IOPS) internal block devices =96 8 in
total.  They are capable of achieving > 1million iops.

However if I use RAID1 / 10 then MD seems to use a single thread which
will reach 100% CPU utilisation (single core) at around 200K IOPS.
Limiting the entire performance to around 200K.

If I use say 4 x RAID1 / 10=92s and a RAID0 on top =96 I see not much
greater results. (although the theory seems to say I should and there
are now 4 CPU threads running, it still seems to hit 4 x 100% at maybe
350K).

Is there any way to increase the number of threads per RAID set? Or
any other suggestions on configurations?  (I have tried every
permutation of R0+R1/10=92s)

Thank you for any advice.


Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
