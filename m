From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 0 of 10 - Intro
Date: Fri, 16 Jan 2004 12:19:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIe9-0002Tq-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi.
 Following are 10 patches for md in 2.6.1-lastest.
 
 1-6 are simple bugfixes that I am confident should be in 2.6.2.

 7 is a bugfix that is fairly important, but could probably do with a
 bit more testing first.  It is not impossible that it could deadlock,
 though I think I have caught and fixed all the problems.

 8-10 are code simplication.

 So maybe 7-10 should only go in -mm for now, but if it is a while
 before 2.6.2, then maybe they can go in a 2.6.2-pre.

Thanks,
NeilBrown
