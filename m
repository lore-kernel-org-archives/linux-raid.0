From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 0/3] deal with imsm spares in Incremental
Date: Tue, 4 Jan 2011 15:03:04 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759FDE@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi Neil,
Some time ago you suggested that Incremental may migrate spares from spare-container
when it is ready to start array as it is impossible to know array's domain before we have all members.
Here are patches that do this.
First two patches modify slightly existing functions to be able to use them in Incremental too.
Third one does the work.
Regards
Anna

0001-Use-one-function-chosing-spares-from-container.patch
0002-move_spare-function-modified-and-moved-to-Manage.c.patch
0003-Incremental-move-suitable-spares-to-container-when-s.patch
 
 Incremental.c |   45 +++++++++++++++++++++++++
 Manage.c      |   44 ++++++++++++++++++++++++
 Monitor.c     |  102 +++++++++-----------------------------------------------
 mdadm.h       |    7 +++-
 super-intel.c |   46 ++++++++++++++++++++-----
 5 files changed, 149 insertions(+), 95 deletions(-)
