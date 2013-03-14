From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID 0 of Two RAID 5s Stays Up When Component RAID fails
Date: Thu, 14 Mar 2013 12:09:54 -0600
Message-ID: <3CD9214B-FAE8-4DA5-BDBC-7A5FEB5AEC4B@colorremedies.com>
References: <loom.20130314T022616-853@post.gmane.org> <loom.20130314T050243-974@post.gmane.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130314T050243-974@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joel Young <jdy@cryregarder.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 13, 2013, at 10:03 PM, Joel Young <jdy@cryregarder.com> wrote:

> Joel Young <jdy <at> cryregarder.com> writes:
>> mdadm /dev/md0 --fail /dev/loop0
>> mdadm /dev/md0 --fail /dev/loop1
> 
> That is a typo.  It is:
> 
> mdadm /dev/md0 --fail /dev/loop1
> mdadm /dev/md0 --fail /dev/loop2

In this case md0 is failed. And thus md2 is failed.

> dd if=/dev/zero of=/dev/md2 bs=1M

The block device is expected to still be there, I'm not sure what errors you should get, but if it were a real physical block device than a logical one, I'd expect there'd be messages in dmesg.

If you had a mounted file system you were trying to write to I think you'd get more immediate error messages in the shell, not just in dmesg.


Chris