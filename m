From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Use RAID-6!
Date: Tue, 16 Apr 2013 15:44:03 -0700
Message-ID: <516DD433.50100@tigertech.com>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DAF21.5040409@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/16/13 1:05 PM, Carsten Aulbert wrote:

> The problem I find with RAID1 is that it won't protect you against
> silent corruptions (same as RAID5). What do you do if you do a through
> check and both drives claim a data block is valid and intact, but data
> differs? Do you trust disk1 or disk2?

That's partly why we use three-disk arrays instead of two-disk.

But as you say, this general issue is a problem with RAID 5 too. We plan
to switch to Btrfs as soon as doing so is wise.

In the meantime, I'd rather risk this problem than the endless reports
of complete array failures that appear on the list with RAID 5 and even
RAID 6 (a recent topic, I note, was "multiple disk failures in an md
raid6 array"). I almost never see anyone reporting complete loss of a
RAID 1 array.

The fundamental difference between RAID 1 and other levels seems to be
that the usefulness of an individual array member doesn't rely on the
state of any other member. This vastly reduces the impact of failures on
the overall system. After using mdadm with various RAID levels since
2002 (thanks, Neil), I'm convinced that RAID 1 is by its very nature far
less fragile than any other scheme. This belief is sadly reinforced
almost every week by a new tale of woe on the mailing list.

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
