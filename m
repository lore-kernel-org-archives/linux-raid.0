From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 2] Introduction
Date: Fri, 03 Sep 2004 12:27:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040903122034.15346.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Two patches for md in 2.6.9-rc1-mm2

The first adds support for notifying user-space of events in md.

The mechanism is very simple.  A reader of /proc/mdstat can select for
"exceptional" events.  When select/poll indicates one of these, the 
reader should re-read /proc/mdstat from the top looking for changes, and then
select again.

If the reader opens for write as well (O_RDWR) (only root can do
this), then it indicates that it is prepared to take remedial action.
This is currently only relevant for multipath.  On last-drive-failure,
if there is a reader of /proc/mdstat that has an open for write, then
multipath will wait for that reader to add a new drive or take other
action before resubmitting the failed requests.

The second patch just fixes a counter in raid5/6 which could get out-by-one, and so
produce confusing messages.

(I think I sent a single item of junk just before this, sorry about that.  Please
ignore it).

NeilBrown

