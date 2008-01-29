From: Neil Brown <neilb@suse.de>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 16:08:50 +1100
Message-ID: <18334.46306.611615.493031@notabene.brown>
References: <479EAF42.6010604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Moshe Yudkowsky on Monday January 28
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 28, moshe@pobox.com wrote:
> 
> Perhaps I'm mistaken but I though it was possible to do boot from 
> /dev/md/all1.

It is my understanding that grub cannot boot from RAID.
You can boot from raid1 by the expedient of booting from one of the
halves.
A common approach is to make a small raid1 which contains /boot and
boot from that.  Then use the rest of your devices for raid10 or raid5
or whatever.
> 
> Am I trying to do something that's basically impossible?

I believe so.

NeilBrown
