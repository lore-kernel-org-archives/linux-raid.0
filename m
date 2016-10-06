From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: MD-RAID: Fine-tuning for several function implementations
Date: Thu, 6 Oct 2016 10:46:45 +0200
Message-ID: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 6 Oct 2016 10:10:01 +0200

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (54):
  raid0: Use kcalloc() in create_strip_zones()
  raid0: Less function calls in create_strip_zones() after error detection
  raid0: Move a variable assignment in create_strip_zones()
  raid0: Replace printk() calls by the usage of higher level interfaces
  raid0: Move another variable assignment in create_strip_zones()
  raid0: Delete four unwanted spaces behind function names
  raid0: Move two misplaced braces
  raid0: Delete an unnecessary return statement in raid0_status()
  raid0: Add some spaces for better code readability
  raid1: Use kcalloc() in alloc_behind_pages()
  raid1: Use kcalloc() in raid1_reshape()
  raid1: Use kcalloc() in setup_conf()
  raid1: Return directly after a failed kzalloc() in setup_conf()
  raid1: Move assignments for the variable "err" in setup_conf()
  raid1: Less function calls in setup_conf() after error detection
  raid1: Delete an error message for a failed memory allocation
  raid1: Move a brace for a designated initialiser
  raid1: Adjust 12 checks for null pointers
  raid1: Replace printk() calls by the usage of higher level interfaces
  raid1: Add some spaces for better code readability
  raid1: Delete three unwanted spaces behind asterisks
  raid1: Delete three unwanted spaces before increment operators
  raid1: Replace a seq_printf() call by seq_puts() in raid1_status()
  raid1: Improve another size determination in setup_conf()
  raid5: Use kcalloc() in three functions
  raid5: Improve another size determination in setup_conf()
  raid5: Return directly after a failed kzalloc() in setup_conf()
  raid5: Rename a jump label in setup_conf()
  raid5: Return directly after a failed kcalloc() in alloc_thread_groups()
  raid5: Delete two error messages for a failed memory allocation
  raid5: Adjust two function calls together with a variable assignment
  raid5: Move a brace for three designated initialisers
  raid5: Replace printk() calls by the usage of higher level interfaces
  raid5: Delete indentation for two jump labels
  raid5: Adjust 13 checks for null pointers
  raid5: Delete four unwanted spaces behind function names
  raid5: Replace a seq_printf() call by seq_puts() in raid5_status()
  raid5: Move four asterisks
  raid5: Add some spaces for better code readability
  raid10: Use kcalloc() in two functions
  raid10: Improve another size determination in setup_conf()
  raid10: Delete an error message for a failed memory allocation
  raid10: Return directly after detection of unsupported settings in setup_conf()
  raid10: Return directly after a failed kzalloc() in setup_conf()
  raid10: Move assignments for the variable "err" in setup_conf()
  raid10: Less function calls in setup_conf() after error detection
  raid10: Improve another size determination in raid10_start_reshape()
  raid10: Move a brace for a designated initialiser
  raid10: Replace printk() calls by the usage of higher level interfaces
  raid10: Delete indentation for one jump label
  raid10: Adjust 22 checks for null pointers
  raid10: Replace a seq_printf() call by seq_puts() in raid10_status()
  raid10: Delete two unwanted spaces behind asterisks
  raid10: Add some spaces for better code readability

 drivers/md/raid0.c  | 170 ++++++++---------
 drivers/md/raid1.c  | 285 ++++++++++++++--------------
 drivers/md/raid10.c | 366 ++++++++++++++++++------------------
 drivers/md/raid5.c  | 523 ++++++++++++++++++++++++----------------------------
 4 files changed, 649 insertions(+), 695 deletions(-)

-- 
2.10.1
