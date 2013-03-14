From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID 0 of Two RAID 5s Stays Up When Component RAID fails
Date: Wed, 13 Mar 2013 21:21:39 -0600
Message-ID: <13BA178C-2888-41FA-A237-13C1423794C4@colorremedies.com>
References: <loom.20130314T022616-853@post.gmane.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130314T022616-853@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joel Young <jdy@cryregarder.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 13, 2013, at 7:33 PM, Joel Young <jdy@cryregarder.com> wrote:
> 
> mdadm /dev/md0 --fail /dev/loop0

loop0 isn't defined in any of your raids.


> mdadm /dev/md0 --fail /dev/loop1

This causes md0 to be degraded.

> mdadm --detail /dev/md0
> mdadm --detail /dev/md2
> dd if=/dev/zero of=/dev/md2 bs=1M
> 
> Shouldn't /dev/md2 be failed at this point?

No.


Chris Murphy

