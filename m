From: Jani Averbach <jaa@cc.jyu.fi>
Subject: BUG: 2.5.41 left raid array to unclean mode (Kernel bug at raid1.c:667)
Date: Tue, 8 Oct 2002 02:49:35 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0210080229560.5342-100000@tukki.cc.jyu.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: mingo@redhat.com, neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

(Resending this, orig was 2002-03-10)

[1.] One line summary of the problem:

Shutdown left (always) software raid array in unclean mode, next shutdown
(during reconstructing) will cause kernel bug.

[2.] Full description of the problem/report:

With 2.5.6 (and 2.5.6-pre1 at least) shutdown procedure left raid
array in unclean state. Next time when machine is going down (during
reconstruction) there will be kernel bug in the raid1.c:656. This is
completely reproductable.

If you run shutdown after reconstruction has been finished, there is no
problem. However raid array is again left in unclean mode.
...

This is still the case with kernel 2.5.41.

Please see details from here:

http://marc.theaimsgroup.com/?l=linux-raid&m=101576857227286&w=2

It would be really nice if this one get nailed down. I would like to test
2.5.x again, but at the moment it is a bit no go.

Thanks for the hacking kernel!

BR, Jani

--
Jani Averbach

