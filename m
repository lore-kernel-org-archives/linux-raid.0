From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID10 overwrites partition tables
Date: Sat, 27 Nov 2004 11:02:24 +1100
Message-ID: <16807.50192.233832.966091@cse.unsw.edu.au>
References: <10578812.1101490100216.JavaMail.www@wwinf3001>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S263119AbUK0AK4@vger.kernel.org>
In-Reply-To: message from Felix Bellaby on Friday November 26
Sender: linux-kernel-owner@vger.kernel.org
To: member@bellaby.freeserve.co.uk
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 26, member@bellaby.freeserve.co.uk wrote:
>    	 mdadm --level 10 does not seem to respect disk partition boundaries.

Hmmm, yes, thanks.

I think the following should fix the bug.  It only affects 'resync'
not normal IO or recovery (after a drive has failed).

(I only tested it on whole-drives....)

Please let me know if it helps.

NeilBrown


 ----------- Diffstat output ------------
 ./drivers/md/raid10.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-11-16 16:33:50.000000000 +1100
+++ ./drivers/md/raid10.c	2004-11-27 11:00:06.000000000 +1100
@@ -1150,6 +1150,7 @@ static void sync_request_write(mddev_t *
 		md_sync_acct(conf->mirrors[d].rdev->bdev, tbio->bi_size >> 9);
 
 		tbio->bi_sector += conf->mirrors[d].rdev->data_offset;
+		tbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		generic_make_request(tbio);
 	}
 
