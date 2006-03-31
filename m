From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Re[2]: Recommendations for supported 4-port SATA PCI card ?
Date: Fri, 31 Mar 2006 14:48:51 +0400
Message-ID: <1692031240.20060331144851@2ka.mipt.ru>
References: <Pine.LNX.4.44.0603302227150.18644-100000@coffee.psychology.mcmaster.ca>
 <Pine.GSO.4.64.0603311122330.2115@montezuma.acc.umu.se>
 <Pine.LNX.4.62.0603310524060.7170@chaos.egr.duke.edu>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0603310524060.7170@chaos.egr.duke.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Joshua,

JBL> That's exactly why I recommended them.  3w-xxxx has been in the kernel a
JBL> *long* time and is extremely stable.  Sure, it's expensive for "just" a
JBL> SATA controller, but not for a solid one that doesn't fall over at random
JBL> times.
Just for my 2 cents: we have a number of different generations of
3Ware cards (IDE and SATA) in our campus network, mostly with Western
Digital drives.

It seems quite beneficial to use their Raid Edition series of drives
instead of desktop ones. Beside the longer warranty and perhaps better
manufacturing and better resistance to vibration, according to the WD
site, these drives also report errors (if any) quicker to a host
adapter. This results in errors being handled by RAID hardware
gracefully, instead of the whole drive being considered as timed out.

In practice, we had some fun months with a RAID5 set made of desktop
Caviars rebuilding once in a while for no apparent reason, with each
disk working well for a long time. And we had no such problem with
RE disks for over a year now.

Hope this helps some list readers make their choice, and please don't
consider this an advertisement of certain brands ;) If any other
manufaturer offers capabilities similar to WD RE (especially timeouts),
please take a better look if you consider a hardware RAID controller.

-- 
Best regards,
 Jim Klimov                            mailto:klimov@2ka.mipt.ru

