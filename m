From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH] fix: mdadm -Ss for external metadata don't stop container
Date: Tue, 7 Dec 2010 06:44:21 +0000
Message-ID: <66C59AD0932712458090B447266D638C010BD52A8E@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

Neil,

The one below is a fix for the problem we encounter quite often when we try to stop all arrays with mdadm -Ss. The main problem is that mdmon holds open container device and then exits. The time that system make clean up is quite long and mdadm invokes ARRAY_STOP ioctl when device is still opened. 
Second resolution is to retry ioctl in mdadm after mdmon exits, but closing handle is I what should be done before process exist.
Take a look at the patch below:

--
Sometimes (~50%) mdadm -Ss cannot stop container as mdmon opens its device
and do not close it before exit(). The period between open and release of
handle is too long and md is not able stop device. Releasing handle before
exit does not block md.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 monitor.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 59b4181..f166bc8 100644
--- a/monitor.c
+++ b/monitor.c
@@ -525,6 +525,7 @@ static int wait_and_act(struct supertype *container, int nowait)
 				remove_pidfile(container->devname);
 			exit_now = 1;
 			signal_manager();
+			close(fd);
 			exit(0);
 		}
 	}
-- 
1.7.1

