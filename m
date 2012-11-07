From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Error correction and Bad block tracking in RAID5
Date: Wed, 7 Nov 2012 19:49:54 +0800
Message-ID: <CAKTMprPUvV57khuKPQ20vyvOxTBiO7=t=ddNu4H0O0YC1jtJHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

I have tried to understand how RAID5 works in linux-3.6.4 by tracing
the raid5.c in md driver.
After days of work on the source code, I get confused by the error
correction and bad block tracking   mechanism.
I try to come up with some conclusions, but I don't know if I am right or not.
Here's my findings these days, hope someone could correct me if I am wrong.

In RAID5, the bad block will be identified and register to upper layer
under two conditions:
1. When read error occurs, we success to rewrite the data back but
fail to re-read it back
2. When write error occurs

Since write error is critical, we prevent the error disk from being
written again, which makes the bad block registered by write errors
impossible to be corrected again.

On the other hands, the following read or write on the known bad
blocks registered by read errors could possibly make bad block "good"
again, and then we can unregister these bad blocks.

Therefore, comparing to older version of md, the benefit of
introducing bad block tracking into RAID5 is that we reserve the
possibility that a read error block could still be corrected by
following read/write.
(In older version, the code simply called md_error when re-read still
fails upon a read error)

Thanks for your patience.
Any help would be grateful

Dennis
