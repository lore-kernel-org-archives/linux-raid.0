From: Mario 'BitKoenig' Holbe <Mario.Holbe@RZ.TU-Ilmenau.DE>
Subject: Re: [PATCH] md - 8 of 8 - Support reshaping raid1 arrays - adding or removing drives.
Date: Fri, 28 May 2004 15:32:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c97f1f$hmm$1@sea.gmane.org>
References: <20040528163700.9426.patches@notabene> <E1BTb7N-0002U9-H3@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
> This requires allocating a new pool of "r1bio" structures which a different
> number of bios, suspending IO, and swapping the new pool in place of the old.
> (and a few other related changes).

Hmmm, I'm not really familiar with the md-code, but doesn't
do memory allocation at runtime re-introduce the 2.2. swap-
on-raid-problems?
Afair, they were due to swap out -> md driver allocates
something -> no ram -> swap out -> md driver allocates ...


regards,
   Mario
-- 
[mod_nessus for iauth]
<delta> "scanning your system...found depreciated OS...found
        hole...installing new OS...please reboot and reconnect now"

