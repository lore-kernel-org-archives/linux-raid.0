From: klink@clouddancer.com (Colonel)
Subject: (unknown)
Date: Sun,  2 Jun 2002 04:20:56 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020602112056.2FEB38347@phoenix.clouddancer.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To: linux-raid@vger.kernel.org
Subject: OOPS on raidtools-20010914
Reply-to: klink@clouddancer.com
From: Colonel <klink@clouddancer.com>


I recently switched to these tools, I'd been using the 1999 ones
previously.  I run striped mirrors for /usr, I must (apparently)
manually start that meta-device as part of the startup scripts.  So
having raidstart and all it's pieces on the / partition is pretty
important.  Imagine my fun after a reboot told me that lilpopt was
unavailable for raidstart, thus I had no /usr and no way to do
anything about it within this machine (because libpopt is stored in
/usr/lib).  Fortunately, I had not upgraded all the other machines to
these newer tools.

Perhaps libpopt is misplaced on my system, or perhaps the raidtool
makefile doesn't expect a manual start raid array....

Any solutions?

Ron
