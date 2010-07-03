From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: List of mismatched blocks?
Date: Sat, 3 Jul 2010 23:29:18 +0200
Message-ID: <slrni2vate.mgo.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <i0nr7l$jge$1@dough.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Niobos <niobos@dest-unreach.be> wrote:
> Weekly, I'm checking my RAID1 array using:
> Every few weeks, I get a mismatch count (which are easily solved with a

Which kernel version and which filesystem on top of the RAID1?

> "sync"). Is there an easy way to get a list of blocknumbers that
> mismatch? I'd like to figure out what may be causing this mismatch.

You can just cmp -l your component devices and get a list of addresses
and mismatches - easy to convert to block numbers. For ext2/3 I'd bet
the mismatches are in inode blocks.


regards
   Mario
-- 
Um mit einem Mann gluecklich zu werden, muss man ihn sehr gut
verstehen und ihn ein bisschen lieben.
Um mit einer Frau gluecklich zu werden, muss man sie sehr lieben
und darf erst gar nicht versuchen, sie zu verstehen.

