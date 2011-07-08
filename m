From: "Tyler J. Wagner" <tyler@tolaris.com>
Subject: Re: Resolving mdadm built RAID issue
Date: Fri, 08 Jul 2011 20:22:16 +0100
Message-ID: <1310152936.3079.5.camel@baal>
References: <C70A636B101FD44999B82525C3E92AFAD8CB1E@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C70A636B101FD44999B82525C3E92AFAD8CB1E@otis.burlington.evertz.tv>
Sender: linux-raid-owner@vger.kernel.org
To: Sandra Escandor <sescandor@evertz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2011-07-08 at 14:07 -0400, Sandra Escandor wrote:
> I am trying to help someone out in the field with some RAID issues, and
> I'm a bit stuck. The situation is that our server has an ftp server
> storing data onto a RAID10. There was an Ethernet connection loss (looks
> like it was during an ftp transfer) and then the RAID experienced a
> failure. From the looks of the dmesg output below, I suspect that it
> could be a member disk failure (perhaps they need to get a new member
> disk?). But, even still, this shouldn't cause the RAID to become
> completely unusable, since RAID10 should provide redundancy - a resync
> would start automatically once a new disk is inserted, correct? 

It does appear that you've had a disk failure on /dev/sde. However, I
can't tell from the dmesg output alone what is the current state of
array. Please give us the output of:

cat /proc/mdstat
mdadm --detail /dev/md126

Simply inserting a new disk will not resync the array. You must add the
remove the old disk from the array, and add the new one using:

mdadm --fail /dev/sde --remove /dev/sde
(insert new disk
mdadm --add /dev/sde

However, I'm guessing as to your layout. /dev/sde may not be correct if
you've partitioned the drives. Then it would may be /dev/sde1, or sde2,
etc.

Regards,
Tyler

-- 
"It is an interesting and demonstrable fact, that all children are atheists
and were religion not inculcated into their minds, they would remain so."
   -- Ernestine Rose

