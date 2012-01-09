From: Martin Cracauer <cracauer@cons.org>
Subject: Giving top priority to a rebuild instead of serving userland?
Date: Mon, 9 Jan 2012 09:21:16 -0500
Message-ID: <20120109142116.GA34289@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am doing a resize on a 4 x 1 TB raid5 array (going to 5x 1 TB).

When there is no userland I/O it reports about 1000 minutes to
rebuild.  However, minor amount of userland demand makes it shoot up
to 3500-4000 as the rebuild puts it's own interests behind.

However, the I/O there is garbage, in this case a disk-noisy web
browser.  Can I tell md to give priority to it's rebuild and serve
userland as it pleases with -say- a maximum of 10% rebuild time
increase? Yes I know that'll make the system very sluggy.

I would be finished already but overnight I left a browser tab open
that caused according to iostat 400-500 Blk_wrtn contiguously.  That
is when *not* actually using the browser (I'll report that as a bug).
Now I am still at 38% rebuild.  Didn't seem worth the price I payed :-)

Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
