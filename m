From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 4] md: Make 'repair' actually work for raid1.
Date: Tue, 23 Jan 2007 11:26:52 +1100
Message-ID: <1070123002652.29462@suse.de>
References: <20070123112437.29357.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When 'repair' finds a block that is different one the various
parts of the mirror. it is meant to write a chosen good version
to the others.  However it currently writes out the original data
to each. The memcpy to make all the data the same is missing.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    5 +++++
 1 file changed, 5 insertions(+)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-01-23 11:13:45.000000000 +1100
+++ ./drivers/md/raid1.c	2007-01-23 11:23:43.000000000 +1100
@@ -1221,6 +1221,11 @@ static void sync_request_write(mddev_t *
 					sbio->bi_sector = r1_bio->sector +
 						conf->mirrors[i].rdev->data_offset;
 					sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+					for (j = 0; j < vcnt ; j++)
+						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
+						       page_address(pbio->bi_io_vec[j].bv_page),
+						       PAGE_SIZE);
+
 				}
 			}
 	}
