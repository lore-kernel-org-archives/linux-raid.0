From: dean gaudet <dean@arctic.org>
Subject: Re: limits on raid
Date: Sun, 17 Jun 2007 12:54:12 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706171242390.24938@twinlark.arctic.org>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org>
 <18035.23867.576212.859440@notabene.brown> <20070616140857.GA4206@animx.eu.org>
 <Pine.LNX.4.64.0706161845180.24938@twinlark.arctic.org> <20070617132809.GB7806@animx.eu.org>
 <Pine.LNX.4.64.0706171019490.24938@twinlark.arctic.org> <20070617193025.GA8770@animx.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070617193025.GA8770@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 17 Jun 2007, Wakko Warner wrote:

> What benefit would I gain by using an external journel and how big would it
> need to be?

i don't know how big the journal needs to be... i'm limited by xfs'
maximum journal size of 128MiB.

i don't have much benchmark data -- but here are some rough notes i took
when i was evaluating a umem NVRAM card.  since the pata disks in the
raid1 have write caching enabled it's somewhat of an unfair comparison,
but the important info is the 88 seconds for internal journal vs. 81
seconds for external journal.

-dean

time sh -c 'tar xf /var/tmp/linux-2.6.20.tar; sync'

xfs journal     raid5 bitmap    times
internal        none            0.18s user 2.14s system 2% cpu 1:27.95 total
internal        internal        0.16s user 2.16s system 1% cpu 2:01.12 total
raid1           none            0.07s user 2.02s system 2% cpu 1:20.62 total
raid1           internal        0.14s user 2.01s system 1% cpu 1:55.18 total
raid1           raid1           0.14s user 2.03s system 2% cpu 1:20.61 total
umem            none            0.13s user 2.07s system 2% cpu 1:20.77 total
umem            internal        0.15s user 2.16s system 2% cpu 1:51.28 total
umem            umem            0.12s user 2.13s system 2% cpu 1:20.50 total


raid5:
- 4x seagate 7200.10 400GB on marvell MV88SX6081
- mdadm --create --level=5 --raid-devices=4 /dev/md4 /dev/sd[abcd]1

raid1:
- 2x maxtor 6Y200P0 on 3ware 7504
- two 128MiB partitions starting at cyl 1
- mdadm --create --level=1 --raid-disks=2 --auto=yes --assume-clean /dev/md1 /dev/sd[fg]1
- mdadm --create --level=1 --raid-disks=2 --auto=yes --assume-clean /dev/md2 /dev/sd[fg]2
- md1 is used for external xfs journal
- md2 has an ext3 filesystem for the external md4 bitmap

xfs:
- mkfs.xfs issued before each run using the defaults (aside from -l logdev=/dev/md1)
- mount -o noatime,nodiratime[,logdev=/dev/md1] 

umem:
- 512MiB Micro Memory MM-5415CN
- 2 partitions similar to the raid1 setup
