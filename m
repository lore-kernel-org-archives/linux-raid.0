From: "majianpeng" <majianpeng@gmail.com>
Subject: question about:raid1 fix_read_error
Date: Wed, 11 Apr 2012 13:09:01 +0800
Message-ID: <201204111308528593924@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,Neil
	I readed the code of raid1:fix_read_error().I find some problem:
1:In order to find other correct data, your code only judge :
				rdev &&
			    test_bit(In_sync, &rdev->flags) &&
			    is_badblock(rdev, sect, s,
					&first_bad, &bad_sectors) == 0 &&
			    sync_page_io(rdev, sect, s<<9,
					 conf->tmppage, READ, false))
 	But the spare disk which is woring ? you can use spare disk is read_balance().
	If you can using spare disk why you set bad blocks?
2: about set bad blocks,when did not find correct data.
	You only:
	struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
			if (!rdev_set_badblocks(rdev, sect, s, 0))
				md_error(mddev, rdev);
	But the other disks which you try to find.
	If you did not set all disks,then in read_balance will read other disk which call in fix_read_error.But the result is the same,
	read error and  set badsectors.
--------------
majianpeng
2012-04-11

