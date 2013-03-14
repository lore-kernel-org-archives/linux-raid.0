From: Joel Young <jdy@cryregarder.com>
Subject: Re: RAID 0 of Two RAID 5s Stays Up When Component RAID fails
Date: Thu, 14 Mar 2013 04:03:48 +0000 (UTC)
Message-ID: <loom.20130314T050243-974@post.gmane.org>
References: <loom.20130314T022616-853@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joel Young <jdy <at> cryregarder.com> writes:
> mdadm /dev/md0 --fail /dev/loop0
> mdadm /dev/md0 --fail /dev/loop1

That is a typo.  It is:

mdadm /dev/md0 --fail /dev/loop1
mdadm /dev/md0 --fail /dev/loop2

which should be clear since there was no loop0 created.

Thanks for the on list and off list notifications of my sloppiness :-)

Joel

