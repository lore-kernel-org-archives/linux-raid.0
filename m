From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Use RAID-6!
Date: Tue, 16 Apr 2013 12:52:18 -0700
Message-ID: <516DABF2.5050409@tigertech.com>
References: <15345091.8.1366130671716.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15345091.8.1366130671716.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/16/13 9:44 AM, Roy Sigurd Karlsbakk wrote:

> So, if you can afford another drive, please use RAID-6. Do *not* trust RAID-5 with something like 8 drives.

Yep. This has been true for many years, too:

 http://www.miracleas.com/BAARF/

I personally don't even trust RAID 6. All our servers use three-disk
RAID 1 setups, with disks from at least two different manufacturers to
prevent against firmware bricking (although this is becoming more and
more difficult as the industry consolidates).

If (no, scratch that, "when") something goes horribly wrong, I can mount
any of the disks as normal, non-RAID volumes. All I need is one disk to
work. (If none of the disks are working, the RAID level is irrelevant...
 ;-)

To me, that level of confidence is worth sacrificing quite a bit of
performance and capacity. It has saved my bacon at least once.

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
