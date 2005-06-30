From: Eric Pretorious <eric@pretorious.net>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Wed, 29 Jun 2005 18:08:54 -0700
Message-ID: <200506291808.54549.eric@pretorious.net>
References: <200506291538.03233.eric@pretorious.net> <200506291738.30516.eric@pretorious.net>
Reply-To: eric@pretorious.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506291738.30516.eric@pretorious.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mike V <mike@asacomputers.com>, tech@asacomputers.com, Dinesh <dinesh@asacomputers.com>
List-Id: linux-raid.ids

On Wednesday 29 June 2005 05:38 pm, Eric Pretorious wrote:
>So it would appear that sda7 has failed. Is that correct?

I was in the process of reading this portion of /var/log/messages...

>SCSI disk error : host 0 channel 0 id 0 lun 0 return code = 10000
>I/O error: dev 08:07, sector 2980224
>raid1: disk failure on sda7, disabling device.
>	Operation continuing on 1 devices
>raid1: mirro resync was not fully finished, restarting next time.
>md4: no spare disk to reconstruct array! -- continuing in degraded mode
>md: md_do_sync() got signal ... exiting
>  ...
>md: autorun
>md: considering sdb7 ...
>md:  adding sdb7 ...
>md:  adding sdb7 ...
>md: created md4
>md: bind<sda7,1>
>md: bind<sdb7,2>
>md: running: <sdb7><sda7>
>md: sdb7's event counter: 0000002b
>md: sda7's event counter: 0000002a
>md: superblcokc update time inconsistency -- using the most recent one
>md: freshest: sdb7
>md4: kicking faulty sda7! 
>md: unbind<sda7,1>
>md: export rdev(sda7)
>mf: md4: raid array is not clean -- starting background reconstruction

...when the system choked, again.  Ug!

I expected that a mirror would be more robust than to bring-down the entire 
system when one RAID member fails. Was this assumption incorrect?

-- 
Eric P.,
Truckee, CA
