From: David Greaves <david@dgreaves.com>
Subject: Serious XFS bug in 2.6.17 kernels - FYI
Date: Thu, 20 Jul 2006 21:07:07 +0100
Message-ID: <44BFE26B.4060703@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just an FYI for my friends here who may be running 2.6.17.x kernels and
using XFS and who may not be monitoring lkml :)

There is a fairly serious corruption problem that has recently been
discussed on lkml and affects all 2.6.17 before -stable .7 (not yet
released)

Essentially the fs can be corrupted and it's serious because the current
xfs_repair tools may make the problem worse, not better.

There is a 1-line  patch that can be applied :
  http://marc.theaimsgroup.com/?l=linux-kernel&m=115315508506996&w=2

FAQ message here
  http://marc.theaimsgroup.com/?l=linux-xfs&m=115338022506482&w=2

FAQ:
  http://oss.sgi.com/projects/xfs/faq.html#dir2

It appears that efforts are being focused on the repair tools now.

It appears to me that the best response is to patch the kernel, reboot,
backup the fs, recreate the fs and restore - but please read up before
taking  any action.

David

-- 
