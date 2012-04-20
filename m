From: Dan Carpenter <dan.carpenter@ORACLE.COM>
Subject: re: md/bitmap: move some fields of 'struct bitmap' into a 'storage'
 substruct.
Date: Fri, 20 Apr 2012 16:13:36 +0300
Message-ID: <20120420131336.GA26339@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello NeilBrown,

This is a semi-automatic email about new static checker warnings.

The patch 9159d8a35d0a: "md/bitmap: move some fields of 'struct
bitmap' into a 'storage' substruct." from Apr 19, 2012, leads to the
following Smatch complaint:

drivers/md/bitmap.c:1212 bitmap_daemon_work()
	error: we previously assumed 'bitmap->storage.filemap' could be
	       null (see line 1145)

drivers/md/bitmap.c
  1144			bitmap->need_sync = 0;
  1145			if (bitmap->storage.filemap) {
                            ^^^^^^^^^^^^^^^^^^^^^^^
Renamed check.

  1146				sb = kmap_atomic(bitmap->storage.sb_page);
  1147				sb->events_cleared =
  1148					cpu_to_le64(bitmap->events_cleared);
  1149				kunmap_atomic(sb);
  1150				set_page_attr(bitmap, 0,
  1151					      BITMAP_PAGE_NEEDWRITE);
  1152			}
  1153		}

[snip]

  1210			if (test_and_clear_page_attr(bitmap, j,
  1211						     BITMAP_PAGE_NEEDWRITE)) {
  1212				write_page(bitmap, bitmap->storage.filemap[j], 0);
                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^
Renamed dereference.

  1213				if (!bitmap->storage.filemap)
                                     ^^^^^^^^^^^^^^^^^^^^^^^
Another check.

  1214					break;

Really, this isn't a new warning, it's just shows up as a new warning
because of the rename.  Still, I was curious about the check after the
dereference.

regards,
dan carpenter

