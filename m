From: Davor Vusir <davortvusir@gmail.com>
Subject: Fwd: [PATCH v3 0/8] MD: a caching layer for raid5/6
Date: Thu, 04 Jun 2015 21:29:12 +0200
Message-ID: <5570A708.9060104@gmail.com>
References: <cover.1433356864.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1433356864.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry for intruding on the patch reviewing process and for the novice=20
question.

Is this caching layer also suitable for a smaller system with only one=20
raid5 where /boot and / resides? Or is it meant for dedicated data=20
storage(s) only?

Regards
Davor Vusir



-------- Vidarebefordrat meddelande --------
=C4mne: [PATCH v3 0/8] MD: a caching layer for raid5/6
Datum: Wed, 3 Jun 2015 15:48:35 -0700
=46r=E5n: Shaohua Li <shli@fb.com>
Till: linux-raid@vger.kernel.org
Kopia: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org,=20
dan.j.williams@intel.com, neilb@suse.de

Hi,

This is the third version of the raid5/6 caching layer patches. The=20
patches add
a caching layer for raid5/6. The caching layer uses a SSD as a cache fo=
r=20
a raid
5/6. It works like the similar way of a hardware raid controller. The=20
purpose
is to improve raid performance (reduce read-modify-write) and fix write=
 hole
issue. The main patch is patch 3 and the description has all details=20
about the
implementation. Please review!

Thanks,
Shaohua

V3:
-make reclaim multi-thread
-add statistics in sysfs
-bug fixes

V2:
-metadata write doesn't use FUA
-discard request is only issued when necessary
-bug fixes and cleanup

Shaohua Li (7):
   raid5: directly use mddev->queue
   raid5: A caching layer for RAID5/6
   raid5: add some sysfs entries
   md: don't allow resize/reshape with cache support
   raid5: skip resync if caching is enabled
   raid5: guarantee cache release stripes in correct way
   raid5: multi-thread support for raid5 caching reclaim

Song Liu (1):
   MD: add a new disk role to present cache device

  drivers/md/Makefile            |    2 +-
  drivers/md/md.c                |   14 +-
  drivers/md/md.h                |    4 +
  drivers/md/raid5-cache.c       | 3775=20
++++++++++++++++++++++++++++++++++++++++
  drivers/md/raid5.c             |  177 +-
  drivers/md/raid5.h             |   25 +-
  include/uapi/linux/raid/md_p.h |   73 +
  7 files changed, 4022 insertions(+), 48 deletions(-)
  create mode 100644 drivers/md/raid5-cache.c

--=20
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
