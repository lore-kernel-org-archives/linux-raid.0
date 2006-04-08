From: Alex Tomas <alex@clusterfs.com>
Subject: linear writes to raid5
Date: Sat, 08 Apr 2006 04:17:35 +0400
Message-ID: <m37j60udi8.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: alex@clusterfs.com
List-Id: linux-raid.ids


Good day all,

is there a way to batch explicitely write requests raid5 issues?
for example, there is a raid5 built from 3 disks with chunk=64K.
one types dd if=/dev/zero of=/dev/md0 bs=128k count=1 and 128K
bio gets into the raid5. raid5 processes the request, does xor
for parity stripe, then issues 2 64KB requests down to lower level.

is it even possible to implement? if so, how complex?

I suppose we could introduce a context which holds last
non-issued bio and instead of generic_make_request() in 
handle_stripe() try to merge current request to the previous
one from the context? how does this sound to you?


thanks, Alex

