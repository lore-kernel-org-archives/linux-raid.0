From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 00/16] md/bitmap: Fine-tuning for several function
 implementations
Date: Tue, 27 Sep 2016 18:44:06 +0200
Message-ID: <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 27 Sep 2016 18:29:08 +0200

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (16):
  Use kmalloc_array() in bitmap_storage_alloc()
  Move an assignment for the variable "offset" in bitmap_storage_alloc()
  Delete an unnecessary variable initialisation in bitmap_storage_alloc()
  Improve another size determination in bitmap_storage_alloc()
  Return directly after a failed bitmap_storage_alloc() in bitmap_resize()
  Return directly after a failed kzalloc() in bitmap_resize()
  Replace a kzalloc() call by kcalloc() in bitmap_resize()
  Rename a jump label in location_store()
  Rename a jump label in bitmap_copy_from_slot()
  Rename a jump label in bitmap_create()
  Rename a jump label in bitmap_init_from_disk()
  One check less in read_page() at the end
  Adjust checks for null pointers in 11 functions
  Delete unnecessary braces in bitmap_resize()
  Add spaces around three comparison operators
  Delete an unwanted space in read_sb_page()

 drivers/md/bitmap.c | 110 +++++++++++++++++++++++++---------------------------
 1 file changed, 52 insertions(+), 58 deletions(-)

-- 
2.10.0

