From: Greg KH <gregkh@suse.de>
Subject: [patch 56/67] MD: Fix problem where hot-added drives are not resynced.
Date: Wed, 11 Oct 2006 14:08:27 -0700
Message-ID: <20061011210827.GE16627@kroah.com>
References: <20061011204756.642936754@quad.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161441AbWJKVQo@vger.kernel.org>
Content-Disposition: inline; filename="md-fix-problem-where-hot-added-drives-are-not-resynced.patch"
In-Reply-To: <20061011210310.GA16627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, syrius.ml@no-log.org, Richard Bollinger <rabollinger@gmail.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, torvalds@osdl.org, akpm@osdl.org, alan@lxorguk.ukuu.org.uk, linux-raid@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
List-Id: linux-raid.ids


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Neil Brown <neilb@suse.de>

If a drive is added with HOT_ADD_DISK rather than ADD_NEW_DISK,
saved_raid_disk isn't initialised properly, and the drive can be
included in the array without a resync.


From: Neil Brown <neilb@suse.de>
Cc: <syrius.ml@no-log.org>
Cc: Richard Bollinger <rabollinger@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.18.orig/drivers/md/md.c
+++ linux-2.6.18/drivers/md/md.c
@@ -3867,6 +3867,7 @@ static int hot_add_disk(mddev_t * mddev,
 	}
 	clear_bit(In_sync, &rdev->flags);
 	rdev->desc_nr = -1;
+	rdev->saved_raid_disk = -1;
 	err = bind_rdev_to_array(rdev, mddev);
 	if (err)
 		goto abort_export;

--
