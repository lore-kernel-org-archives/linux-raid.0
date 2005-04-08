From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 000 of 2] Introduction
Date: Fri, 08 Apr 2005 11:41:46 +1000
Message-ID: <20050408113719.27541.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Two patches against 2.6.12-rc2 for md.
(patches apply to 2.6.12-rc2-mm1 with various offsets).

The first closes an extreme small race in md thread deregistration.
This race was actually lost by someone who, due to a different bug
which has since been fixed, has md threads being created and destroyed
at a very high rate.

The second removes a number of MD_BUG calls that that are either
completely pointless, or misleading (i.e. the report a bug when it is
just an unusual condition that is handled correctly).

NeilBrown


 [PATCH md 001 of 2] Close a small race in md thread deregistration
 [PATCH md 002 of 2] Remove a number of misleading calls to MD_BUG
