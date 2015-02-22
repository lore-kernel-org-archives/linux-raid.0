From: Chris <email.bug@arcor.de>
Subject: Re: re-add POLICY
Date: Sun, 22 Feb 2015 13:23:18 +0000 (UTC)
Message-ID: <loom.20150222T140358-20@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <loom.20150217T152416-500@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I just noticed that I somehow overlooked that md3 and md7 on that old ubuntu
system *did* have a write-intent bitmap.

So in my tests action="spare" does not seem to allow automatic re-sync of
arrays without a bitmap.

To quote the man page again on "spare":
"if the device is bare it can become a spare if there is any array that it
is a candidate for based on domains and metadata."

I am fankly not sure I fully understand that. A bare device has no
superblock, so does  mdadm only look which array fits onto the device?
Since the partitions on the removed disk contain superblocks they are not
bare, may that by why action=spare does not apply, and an automatic re-sync
may either require a new action="re-sync" or be done by "re-add" as well?

Regards,
Chris



