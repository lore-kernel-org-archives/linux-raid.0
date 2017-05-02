From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/6] md: Fine-tuning for some function implementations
Date: Tue, 2 May 2017 16:23:43 +0200
Message-ID: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 May 2017 16:12:34 +0200

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (6):
  Replace seven seq_printf() calls by seq_putc()
  Replace 17 seq_printf() calls by seq_puts()
  Adjust four function calls together with a variable assignment
  Use seq_puts() in faulty_status()
  Adjust six function calls together with a variable assignment in faulty_status()
  Add some spaces for better code readability

 drivers/md/faulty.c | 48 ++++++++++++++++++++++----------------
 drivers/md/md.c     | 66 +++++++++++++++++++++++++++++------------------------
 2 files changed, 64 insertions(+), 50 deletions(-)

-- 
2.12.2
