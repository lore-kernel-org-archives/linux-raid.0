From: Artur Wojcik <artur.wojcik@intel.com>
Subject: Re: [patch 0/1][mdadm] Fix needed to enable RAID volumes on SAS
 devices (version 2).
Date: Mon, 30 Nov 2009 16:12:13 +0100
Message-ID: <1259593933.3178.122.camel@awojcik-linux>
References: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>
	 <20091113193545.GW21495@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091113193545.GW21495@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>, Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Neil/Andre,
I incorporated the suggestions Andre gave me and this resulted in the
second version of patch. However I decided to not use pathconf()
function but to define PATH_MAX instead. It is just the size of a buffer
and I would like this to be resolved during compilation time rather then
dynamically during execution time. Please review it and let me know if
something needs to be changed.

As for the being paranoid... so I really am, if we talk about software
security and vulnerability. I decided to introduce a new __str_fmt()
function and str_fmt() helper macro. Both are documented in source code
(let me know if you need separate patch for this).

-------------------------------------------------

This fix allows to create a RAID arrays on SAS devices direct-attached
or installed behind an expander. The cause of the problem is assumption
that 50 characters is enough to fit sysfs path of a storage device. This
is true for devices connected to AHCI and IDE controllers. However for
SAS devices (especially installed behind an expander) 'libsas' may
create a path much longer then 50 characters and in consequence the path
is truncated and incorrectly evaluated.
---
 Detail.c         |    5 ++-
 platform-intel.c |   19 ++++++++-------
 super-intel.c    |   27 ++++++++-------------
 sysfs.c          |   59 ++++++++++++++++++++++-------------------------
 util.c           |   55 +++++++++++++++++++++++++++++++++++---------
 util.h           |   67
++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 162 insertions(+), 70 deletions(-)
 create mode 100644 util.h
---
Artur


