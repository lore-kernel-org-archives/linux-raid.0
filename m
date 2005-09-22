From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Thu, 22 Sep 2005 02:14:21 +0200
Message-ID: <20050922001421.GA2205@uio.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au> <20050921192326.GA30405@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050921192326.GA30405@uio.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 21, 2005 at 09:23:26PM +0200, Steinar H. Gunderson wrote:
> I noticed a problem during a big test resize now, BTW; for some reason,
> pdflush goes into uninterruptable sleep, and kjournald and thus the
> filesystem seems to follow. I'm not sure if this is a starvation issue or
> not, but it sure is a bug -- I'll look into it and see if I find something
> obvious.

This might be it (apoligies for the inline patch, but it should be simple
enough to apply by hand):

--- drivers/md/raid5.c.orig     2005-09-22 02:15:30.000000000 +0200
+++ drivers/md/raid5.c  2005-09-22 01:49:30.000000000 +0200
@@ -374,7 +374,7 @@
					BUG();
			} else {
				if (!test_bit(STRIPE_HANDLE, &sh->state)) {
-					if (conf->expand_in_progress && sector < conf->expand_progress) {
+					if (conf->expand_in_progress && sector * (conf->raid_disks - 1) < conf->expand_progress) {
						atomic_inc(&conf->active_stripes_expand);
					} else {
						atomic_inc(&conf->active_stripes);

It seems to survive even under quite heavy load now (but of course, restripe
performance suffers badly when doing heavy stuff on the volume :-) ). Too
soon to say if there are problems still, of course.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
