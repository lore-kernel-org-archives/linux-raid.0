From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 0/6] raid6check fixes
Date: Tue, 18 Jun 2013 11:09:10 +0200
Message-ID: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, piergiorgio.sartor@nexgo.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here are a few raid6check fixes. This series also includes a patch for
Makefile to allow to build with optimizations. I only fixed raid6check
to build with -O3, but I don't have time left today to fix mdadm=20
(e.g. Grow.c:2237:41: error: =E2=80=98info2.data_offset=E2=80=99 may be=
 used uninitialized in this function [-Werror=3Duninitialized])

I wanted to send the memleak-fixes much earlier, but then
I had been too busy. This patch is lightly tested, patches
from today are only build-tested.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
