From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 5] Introduction
Date: Wed, 20 Oct 2004 13:26:20 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041020132354.31830.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Five patches for md in 2.6.latest

The first fixes a very unfortuante bug which causes raid1 to not
survive a a drive failure (the data survives, the the host will need a
reboot :-( )

The remaining 4 fix issues of smaller significance which may affect
some poeple, but not most.

NeilBrown
