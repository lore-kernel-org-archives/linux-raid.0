From: Michal Soltys <soltys@ziu.info>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Wed, 28 Sep 2011 12:38:27 +0200
Message-ID: <4E82F923.8080807@ziu.info>
References: <4E7EDE58.3000804@yazzy.org> <20110926074002.6399de56@notabene.brown> <4E7FA3E8.5010603@yazzy.org> <20110926081853.2819622b@notabene.brown> <4E804062.3020700@yazzy.org> <20110926193130.6377f5b9@notabene.brown> <4E82203A.60507@yazzy.org> <20110928091335.1df35f8e@notabene.brown> <4E828B92.40502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E828B92.40502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: NeilBrown <neilb@suse.de>, lists@yazzy.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W dniu 28.09.2011 04:50, Stan Hoeppner pisze:
>
> Reading the thread, and the many like it over the past months/years, may
> yield a clue as to why you wish to move on to something other than Linux
> RAID...
>

IMHO, in almost all cases - at the end of the chain - is misinformation. 
While this might be a bit bold - a lot of users don't even spend a few 
minutes doing elementary homework like man md/mdadm/mdadm.conf and less 
/usr/src/linux/Documentation/md.txt. Be it normal usage, or when 
problems happen. Rumors and forum wisdom can be really damaging - not to 
look far away - how many people keep believing that xfs eats your data 
and fills it with 0s ?

It's hard to find cases, when md driver or mdadm was really at fault for 
something. For the most part the typical route is: [bottom barrel cheap 
desktop ]hardware/[terribly designed sata ]cable issues -> a user 
applying random googled suggestions (with shaking hands) -> really, 
really bad problems. But that's not md's failure.

I'd put lots of responsibility on [big] distros as well, which have been 
trying (for many years already) to turn linux into layers of gui/script 
wrapped (and often buggy) experience, trying to hide any and all 
technical details at all cost. But that's OT ...


Be it flexibility, recoverability (with cooled head and after panicking 
while being /away/ from the drives and md) or performance (especially 
after some small adjustments - namely stripe_cache_size for write 
speeds) it's hard to challenge md. And some awesome features are coming 
too (e.g. http://thread.gmane.org/gmane.linux.raid/34708 ).
