From: "Mike Snitzer" <snitzer@gmail.com>
Subject: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and internal bitmap
Date: Wed, 17 Oct 2007 11:37:58 -0400
Message-ID: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm 2.4.1 through 2.5.6 works. mdadm-2.6's "Improve allocation and
use of space for bitmaps in version1 metadata"
(199171a297a87d7696b6b8c07ee520363f4603c1) would seem like the
offending change.  Using 1.2 metdata works.

I get the following using the tip of the mdadm git repo or any other
version of mdadm 2.6.x:

# mdadm --create /dev/md2 --run -l 1 --metadata=1.0 --bitmap=internal
-n 2 /dev/sdf --write-mostly /dev/nbd2
mdadm: /dev/sdf appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
mdadm: /dev/nbd2 appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
mdadm: RUN_ARRAY failed: Input/output error
mdadm: stopped /dev/md2

kernel log shows:
md2: bitmap initialized from disk: read 22/22 pages, set 715290 bits, status: 0
created bitmap (350 pages) for device md2
md2: failed to create bitmap (-5)
md: pers->run() failed ...
md: md2 stopped.
md: unbind<nbd2>
md: export_rdev(nbd2)
md: unbind<sdf>
md: export_rdev(sdf)
md: md2 stopped.
