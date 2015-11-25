From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Wed, 25 Nov 2015 10:44:27 -0500
Message-ID: <5655D75B.9020901@turmel.org>
References: <189791448292518@web28m.yandex.ru> <565359F6.3020201@turmel.org>
 <3822301448453563@web17m.yandex.ru> <5655B62F.2070806@turmel.org>
 <240681448462882@web25o.yandex.ru> <939171448463324@web17m.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <939171448463324@web17m.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Semyon Enskiy <semyon.enskiy@yandex.ru>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/25/2015 09:55 AM, Semyon Enskiy wrote:
> Maybe assemble command should include sdj3 device too?
> Like
> # mdadm -v --assemble --update=revert-reshape /dev/md3 /dev/sd[a-j]3
> not
> # mdadm -v --assemble --update=revert-reshape /dev/md3 /dev/sd[a-i]3

Yes, my mistake.  :-(  Try again, including 'sdj3'.

Phil
