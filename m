From: John Rowe <rowe@excc.ex.ac.uk>
Subject: New features?
Date: Tue, 31 Oct 2006 11:23:38 +0000
Message-ID: <1162293818.32109.113.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All this discussion has led me to wonder if we users of linux RAID have
a clear consensus of what our priorities are, ie what are the things we
really want to see soon as opposed to the many things that would be nice
but not worth delaying the important things for. FWIW, here are mine, in
order although the first two are roughly equal priority.

1 "Warm swap" - replacing drives without taking down the array but maybe
having to type in a few commands. Presumably a sata or sata/raid
interface issue. (True hot swap is nice but not worth delaying warm-
swap.)

2 Adding new disks to arrays. Allows incremental upgrades and to take
advantage of the hard disk equivalent of Moore's law.

3. RAID level conversion (1 to 5, 5 to 6, with single-disk to RAID 1 a
lower priority).

4. Uneven disk sizes, eg adding a 400GB disk to a 2x200GB mirror to
create a 400GB mirror. Together with 2 and 3, allows me to continuously
expand a disk array.

(Not knowing the code, I wonder if 2, 3 and 4 could be accomplished by
allowing an "external" RAID device to have several internal devices and
with changes accomplished the old one to shrink and the new one to grow
until the old one no longer exists.)

Thanks for listening.

John



