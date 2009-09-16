From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: mismatch_count != 0 on multiple hosts
Date: Wed, 16 Sep 2009 21:20:35 +0200
Message-ID: <slrnhb2ek3.dbe.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <20090916171714.GA24629@atlantis.cc.ndsu.nodak.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bryan Mesich <bryan.mesich@ndsu.edu> wrote:
> The most popular mismatch_cnt values are 128 and 256.  The worst I=20
> found was 21504 and 7168.  I find it interesting that all are=20
> divisible by 128.

They should not appear on RAID5.

What kinds of filesystems reside on the RAID1s? If it's ext[23] (well,
most likely on SANs it's not :)), then these mismatches are very likely
located in inode blocks.
I've noticed this quite often on RAID1s up to 2.6.26, especially on
filesystems with heavy inode fluctuation (remove, create files).
Starting with .26 (i guess, maybe later) I didn't see them anymore.
Maybe yours on newer kernels are just brownfields? Correct them and see
if they appear again?

> So, is there anyway to get an output on which blocks do not match?  I'd
> like to see how they are different, if at all.

just cmp -l the components, as you did before md brought up the
sync_action check target :)


regards
   Mario
-- 
The question of whether a computer can think is no more interesting than
the question of whether a submarine can swim.          -- E. W. Dijkstra

