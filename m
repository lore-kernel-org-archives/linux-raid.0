From: Shaohua Li <shli@fusionio.com>
Subject: [patch 0/7 v2] MD linear/0/1/10/5 TRIM support
Date: Fri, 10 Aug 2012 10:51:13 +0800
Message-ID: <20120810025113.050392766@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@kernel.org
List-Id: linux-raid.ids

This is the patchset to support MD discard, which I refresh against latest
kernel. It's pretty straightforward for raid linear/0/1/10. The raid456 discard
support is tricky, please see the log in the patches for details.

Previously when I posted the patches out, people complain SATA SSD discard
request merge error. Now a patch to disable discard request merge is in Jens's
tree. We don't have this issue any more.
