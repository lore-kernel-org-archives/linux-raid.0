From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Wed, 25 Nov 2015 12:49:37 -0500
Message-ID: <5655F4B1.4030403@turmel.org>
References: <189791448292518@web28m.yandex.ru> <565359F6.3020201@turmel.org>
 <3822301448453563@web17m.yandex.ru> <5655B62F.2070806@turmel.org>
 <240681448462882@web25o.yandex.ru> <939171448463324@web17m.yandex.ru>
 <5655D75B.9020901@turmel.org> <166511448468944@web24o.yandex.ru>
 <5655E8D1.2050906@turmel.org> <398591448472730@web17m.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <398591448472730@web17m.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Semyon Enskiy <semyon.enskiy@yandex.ru>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/25/2015 12:32 PM, Semyon Enskiy wrote:

> Does you think, that problem is that "Raid Devices : 10", but
> "Array State : AAAAAAAA.A.", where the extra, 11th, device is sdj3, which
> was rejected from system in past, but record about it leave in superblock?

No.  It just can't get past the fact that your array is double-degraded,
even though it isn't really, once the revert succeeds.

At this point, I don't see a way out without --create.  Fortunately, we
have complete details on your array, so we can supply the correct paramters:

mdadm --stop /dev/md3

mdadm --create --assume-clean --chunk=512 --data-offset=262144 \
  --level=5 --raid-devices=10 --metadata=1.2 /dev/md3 \
  /dev/sd{f,i,h,g,d,e,b,c}3 missing /dev/sdj3

Note that you cannot use [] notation -- it doesn't maintain the order of
the letters.  The keyword 'missing' takes the place of /dev/sda3.  It's
possible it would be fine, but I'd rather not risk it.

You should be able to access the content at this point.  Copy out any
super-critical files.  Then add sda3:

mdadm --add /dev/md3 /dev/sda3

This should initiate the rebuild.

Update your mdadm.conf file to use the new UUID, and update your initramfs.

Phil
