From: James Brown <jbrown@orange.net>
Subject: Re: Newbie: Kernel panic during RAID1 test & reboot loses one disk
Date: Tue, 29 Aug 2006 00:08:27 +0200
Message-ID: <44F3695B.6080901@orange.net>
References: <ecqek4$tnu$1@sea.gmane.org> <17650.19291.747235.505927@cse.unsw.edu.au> <44F365D7.2020001@orange.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44F365D7.2020001@orange.net>
Sender: linux-raid-owner@vger.kernel.org
To: James Brown <jbrown@orange.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

James Brown wrote:

> [...]
> There is no mdadm/mdadm.conf! What I should do about this?

Having just read the post from Andreas Pelzner, perhaps I should create 
a new initrd:

 > Andreas Pelzner wrote:
> you told me the rigt way. I had to add the lines "raid1" and "md_mod" to
> /etc/mkinitrd/modules. After recreating the initrd image "mkinitrd -o
> /boot/initrd.img-2.6.17.8 /lib/modules/2.6.17.8" the server boots into
> both raid disk correctly.

I don't understand the "raid1" or "md_mod" steps here. Could anyone 
explain please?

Regards,

James.

