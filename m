From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 2] Introduction
Date: Thu, 10 Feb 2005 09:22:47 +1100
Message-ID: <20050210091909.1612.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Two more little patches for md (sorry for the dribs-and-drabs).

Feel free to leave them until post-2.6.11, though the first is really trivial
and allows md/multipath arrays be assembled (without it they just won't work).

- Fix typo for multipat assembly with will
- Mark raid6 non-experimental and tidy up bits of Kconfig

NeilBrown

