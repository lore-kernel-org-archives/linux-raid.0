From: "Tomi Orava" <tomimo+linux-raid@ncircle.nullnet.fi>
Subject: Re: How safe is software RAID compared to how safe hardware RAID
     is!?
Date: Thu, 20 Nov 2003 22:53:38 +0200 (EET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <48898.192.168.9.10.1069361618.squirrel@ncircle.nullnet.fi>
References: <16314.40792.616508.878124@notabene.cse.unsw.edu.au><PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
    <16314.44161.438158.27514@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16314.44161.438158.27514@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>  I had a mirrored pair that kept getting data corruption.  It turned
>  out that one of the drives had a bad bit in an internal buffer, and
>  would occasionally return 1 for the 12th bit (or similar) of each
>  sector even when it should be zero.   Neither software raid or
>  hardware raid would cope with that.

How did you manage to figure out what was the reason for this
corruption ? I mean, does there exist a some sort of "generic"
way how to solve such errors, or was it just hard work in comparing
what got written to the different disks ...

>  Some people find that their IDE controller works fine until they try
>  to use RAID1.  RAID1 hits multiple discs concurrently a lot, and some
>  (few, specific) ide controllers don't appear to cope.  You probably
>  would not get that with hardware raid.  You can with software raid
>  because it is a "whole-system" thing.

Can you name the controllers which have had problems in this area ?
I'm having big problems in Linux 2.4 kernels IDE-stability with
heavy I/O (all disks are RAID1), perhaps either the Sil680 or
HPT374 are just problematic controllers ... ? (it would be just great
to solve all of these problems by buying new IDE-cards :)

Regards,
Tomi Orava


