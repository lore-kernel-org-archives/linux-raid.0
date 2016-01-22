From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Fri, 22 Jan 2016 12:16:36 -0500
Message-ID: <56A263F4.8020307@turmel.org>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
 <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
 <564284F5.9080409@turmel.org>
 <b0cdddd4394bbc1356980bb61ac199c3@pingofdeath.de>
 <56429326.5030405@turmel.org>
 <a7d58e8e4c319c320bc531b8d2bf11e7@pingofdeath.de>
 <44d28ec402622b25c4d4d7a32a8888d9@pingofdeath.de>
 <569D384F.6070208@turmel.org>
 <bb6cce6b0d5bb6c653ef94e4a58388cf@pingofdeath.de>
 <569E77AF.6040906@turmel.org> <569E905D.9010606@turmel.org>
 <15c75ec959427ae31d36912854b6debd@pingofdeath.de>
 <34ad7f74bc9fdc37aab022054d8d856e@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <34ad7f74bc9fdc37aab022054d8d856e@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Hi Mathias,

On 01/22/2016 04:30 AM, Mathias Mueller wrote:
> Hi Phil,
> 
> it's done:
> 
> 658 Unique hashes in picture.jpg

Looks good.  Rearranging a bit:

>           /dev/sdf1 @ 005400caa000:005400cfffff ~= 00000000:00055fff
>           /dev/sde1 @ 005400b90000:005400c0ffff ~= 00056000:000d5fff
>           /dev/sdd1 @ 005400c80000:005400cfffff ~= 000d6000:00155fff
>           /dev/sdc1 @ 005400d00000:005400d7ffff ~= 00156000:001d5fff
>           /dev/sdf1 @ 005400d00000:005400d7ffff ~= 001d6000:00255fff
>           /dev/sde1 @ 005400c10000:005400c4bfff ~= 00256000:00291fff

>           /dev/sdc1 @ 0087b4f29000:0087b4f7ffff ~= 00000000:00056fff
>           /dev/sdf1 @ 0087b4f00000:0087b4f7ffff ~= 00057000:000d6fff
>           /dev/sde1 @ 0087b4e10000:0087b4e8ffff ~= 000d7000:00156fff
>           /dev/sdd1 @ 0087b4f80000:0087b4ffffff ~= 00157000:001d6fff
>           /dev/sdc1 @ 0087b4f80000:0087b4ffffff ~= 001d7000:00256fff
>           /dev/sdf1 @ 0087b4f80000:0087b4fbafff ~= 00257000:00291fff

>           /dev/sdf1 @ 00cb2d956000:00cb2d97ffff ~= 00000000:00029fff
>           /dev/sde1 @ 00cb2d810000:00cb2d88ffff ~= 0002a000:000a9fff
>           /dev/sdd1 @ 00cb2d980000:00cb2d9fffff ~= 000aa000:00129fff
>           /dev/sdc1 @ 00cb2d980000:00cb2d9fffff ~= 0012a000:001a9fff
>           /dev/sdf1 @ 00cb2d980000:00cb2d9fffff ~= 001aa000:00229fff
>           /dev/sde1 @ 00cb2d910000:00cb2d977fff ~= 0022a000:00291fff

Device order is definitely sdf1, sde1, sdd1, sdc1, sdf1 ....

> End of /dev/sdc1 at 01d1c1016000
> End of /dev/sdd1 at 01d1c1016000
> End of /dev/sde1 at 01d1c0e90000
> End of /dev/sdf1 at 01d1c110e000

sdc1 and sdd1 are the same size and have the same chunk alignment
offsets.  sdf1 is bigger but has the same chunk offsets as sdc1 and
sdd1.  sde1 is smaller than sd[cd]1 by 0x186000 and has chunk offsets
0xf0000 earlier than the others for a given stripe.

sde1 has a data offset that ends in 0x10000 or 0x90000.  0x10000 is 64k,
an offset used by default early in mdadm's history.

The others have data offsets that end in 0x00000 or 0x80000.  0x80000 is
512k.  0x100000 is 1M, another default offset in mdadm history, and
happily the correct increment (0xf0000) bigger than the 64k suspicion I
have for sde1.

Here are the four --create operations I would try:

(This first one is most likely it based on the signature analysis in
November.)

mdadm --create --assume-clean --data-offset=variable \
  --raid-devices=4 --chunk=512 --level=5 /dev/mdX \
  /dev/sdc1:1024 /dev/sdf1:1024 /dev/sde1:64 /dev/sdd1:1024

mdadm --create --assume-clean --data-offset=variable \
  --raid-devices=4 --chunk=512 --level=5 /dev/mdX \
  /dev/sdf1:1024 /dev/sde1:64 /dev/sdd1:1024 /dev/sdc1:1024

mdadm --create --assume-clean --data-offset=variable \
  --raid-devices=4 --chunk=512 --level=5 /dev/mdX \
  /dev/sde1:64 /dev/sdd1:1024 /dev/sdc1:1024 /dev/sdf1:1024

mdadm --create --assume-clean --data-offset=variable \
  --raid-devices=4 --chunk=512 --level=5 /dev/mdX \
  /dev/sdd1:1024 /dev/sdc1:1024 /dev/sdf1:1024 /dev/sde1:64

Phil
