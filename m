From: Chris <email.bug@arcor.de>
Subject: re-add POLICY
Date: Sat, 14 Feb 2015 21:59:34 +0000 (UTC)
Message-ID: <loom.20150214T222329-324@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all,

I'd like mdadm to automatically attempt to re-sync raid members after they
where temporarily removed from the system. 

I would have thought "POLICY domain=default action=re-add" should allow this,
and found a prior post that also seemed to want/test that behaviour.
But as I understand the answer given there
http://permalink.gmane.org/gmane.linux.raid/47516
mdadm is expected to exit with an error (not re-add) upon plugging the
device back in?

with:
mdadm: can only add /dev/loop2 to /dev/md0 as a spare, and force-spare is
not set.
mdadm: failed to add /dev/loop2 to existing array /dev/md0: Invalid argument.

For one, I don't understand what the error messages is trying to tell me, about
an invalid argument that was never supplied to --incremental?

But more importantly, how can priorly diconnected devices (marked failed
with non-future event count) get re-synced automatically when they are 
plugged in again?
(avoiding manual mdadm /dev/mdX --add /dev/sdYZ hassle)

Cheers,
Chris

