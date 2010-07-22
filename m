From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Why is sb->size set to 0 with raid0?
Date: Thu, 22 Jul 2010 13:36:07 +0200
Message-ID: <slrni4gb97.jpi.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <slrni4e7bi.ced.Mario.Holbe@darkside.dyn.samba-tng.org>
 <20100722153456.04f751e7@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
> The 'Used Dev Size' is the amount of each device that is used in the array.
> For RAID0 (and linear), there is no such number.  The devices can be of
> different sizes and in each case "all" of the available space is used.

Hmm, RAID0 has a chunk size - but I guess this is what you meant with
the quotes around "all" :)

> This has nothing to do with the bitmap.  Space reserved for the bitmap is
> out side of the 'Avail Dev Size'.

Sure, it has: having a zero 'Used Dev Size' (i.e. sb->size = 0) results
in not reserving space for a bitmap - at least for v1 superblocks:

		array_size = __le64_to_cpu(sb->size);
		/* work out how much space we left for a bitmap */
		bm_space = choose_bm_space(array_size);

... which I like in case of RAID0 (as I said), but of which I don't know
if you do like it as well ;) - for example, because it also prevents a
bitmap when the RAID0 is later converted to RAID5.


regards
   Mario
-- 
Jene, die grundlegende Freiheit aufgeben wuerden, um eine geringe
voruebergehende Sicherheit zu erwerben, verdienen weder Freiheit noch
Sicherheit.
                                     -- Benjamin Franklin (1706-1790)

