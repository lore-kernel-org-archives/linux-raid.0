From: Semyon Enskiy <semyon.enskiy@yandex.ru>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Wed, 25 Nov 2015 17:55:24 +0300
Message-ID: <939171448463324@web17m.yandex.ru>
References: <189791448292518@web28m.yandex.ru> <565359F6.3020201@turmel.org>
	 <3822301448453563@web17m.yandex.ru> <5655B62F.2070806@turmel.org> <240681448462882@web25o.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <240681448462882@web25o.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maybe assemble command should include sdj3 device too?
Like
# mdadm -v --assemble --update=revert-reshape /dev/md3 /dev/sd[a-j]3
not
# mdadm -v --assemble --update=revert-reshape /dev/md3 /dev/sd[a-i]3
