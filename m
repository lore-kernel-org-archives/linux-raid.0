From: mdw1103 <mdw1103@yahoo.com>
Subject: Live Read Error Correction W/O Reconstruct?
Date: Mon, 23 Jan 2006 20:14:52 -0800 (PST)
Message-ID: <20060124041452.68243.qmail@web35804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In 2004, Mr Brown wrote that read errors could be
handled without reconstruction. Has this been
implemented in 2.6.8? As I understand it,  this is the
way RAID is supposed to work.

For reference, here is the post about the matter:
auto-correcting read errors

Write errors must always fail a device as even if
there was a cable problem rather than a media problem,
the drive will be inconsistant with the array after
the write failure and so cannot be trusted.

However read errors do not have to be fatal. If the
device can over-write a bad sector, or remap to
elsewhere, then it makes sense to regenerate the data
from redundant info and re-write.

It is important that this over-write only be attempted
if it looks like a genuine single block error, rather
than a more major problem such as a head crash.

So, read errors should cause a retry as they currently
do, but they should not immediately fail the whole
drive. Rather just the block that had the error should
be marked failed. A count of failed blocks per drive
must be kept and if this exceed some threshold (20??)
the drive is then failed.

While there are failed blocks below the threshold
number, the raid control thread should instigate
resync on the bad addresses. If a write fails, the
drive is failed. If the write succeeded, a recheck
should be performed to make sure the data really is
good. If this fails, the drive should be failed. But
if it succeeds, the block can be marked good again.

To implement this we need a small list of failed
blocks and the drive on which they are failed. Any
read request to blocks in this list is allowed to
continue but avoid the drive in question. Any write
request blocks until the status of the block is
resolved.

If blocks on different drives fail such that data
cannot be recovered, the array must be failed.
However, failed blocks on different drives at
different addresses need not be a problem.

If read errors are found during resync, we must assume
that those blocks are the out-of-date blocks.

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
