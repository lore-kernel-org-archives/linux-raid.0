From: Chia-Hung Chang <fredchang.tc@gmail.com>
Subject: The problem that trim is malfunction at the present of DM-layer
Date: Tue, 22 Jul 2014 21:05:52 +0800
Message-ID: <CABpYCqaEtgNyW7Az6uWnrWicNURsNqCKOfMM6e4XscLVrrgLtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

List, good morning,
   A Trim command allows an operating system to inform a solid-state
drive (SSD) which blocks of data are no longer considered in use and
can be wiped internally.  In linux, we can use fstrim to discard all
unused blocks in the filesystem. The requests issued from fstrim are
called discard requests. The amount of blocks that are no longer in
use in a discard request is called 'size of the discard request' in
the following context.

  After tracing the code, I found Raid 5/6 only process the discard
requests where size > Chunk_size * disk_num. In my environment, I use
4 disk to build raid 5. So, the discard requests can only been
processed if its size is larger than 512k*3=1.5MB. In my environment,
I have a DM-layer, thin-provisioning, in between Ext4 and raid5. The
data block of thin-provisioning is set to 1MB. So, the discard
requests will be break into several small requests with size <=1MB in
the DM-layer. Consequently, all discard requests will not be processed
in raid5. In this kind of architecture, there won't be any discard
request arrived disks.

  I have an idea to solve the problem. For requests with size <
Chunk_size * disk_num, we don't ignore it. On the contrary, the raid5
driver find corresponding stripes of the requests and process it just
like write requests. For write requests, if a stripe doesn't have
R5_OVERWRITE flag in all data disks, it waits in delayed_list for a
while. For discard requests, if a stripe doesn't have R5_OVERWRITE
flag in all data disks, it waits in another list, said
discard_delayed_list, for a while too. If other discard requests come,
the stripe may have chance to be covered by several requests and be
submitted to the disks. If time-out, the stripe will be throw away. My
question is how to decide 'time-out'. Does anyone have any suggestion?

Sincerely,
Fred
