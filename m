From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: BUG: mdadm --fail makes the kernel lose count (was Re: raid5 won't
 resync)
Date: Wed, 1 Sep 2004 10:36:35 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16693.6547.499464.908456@cse.unsw.edu.au>
References: <200408310408.i7V48p307444@watkins-home.com>
	<Pine.LNX.4.58.0408310401070.1949@web1.mmaero.com>
	<41344360.8060206@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Tuesday August 31
To: David Greaves <david@dgreaves.com>
Cc: Jon Lewis <jlewis@lewis.org>, Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org, aaron@america.com
List-Id: linux-raid.ids

On Tuesday August 31, david@dgreaves.com wrote:
> Neil
> copied you as I think there's a bug in resync behaviour (kernel.org
2.6.6)

Yes, thanks.
It's just a small bug.  It only affect the content of /proc/mdstat
and the "continuing on ... drives" message.
Here is that patch which will be submitted shortly.

Thanks again,
NeilBrown

=============================================
Correct "working_disk" counts for raid5 and raid6

This error only affects two message (and sysadmin heart-rate).
It does not risk data.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid5.c     |    2 +-
 ./drivers/md/raid6main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-08-30 14:43:27.000000000 +1000
+++ ./drivers/md/raid5.c	2004-09-01 10:17:19.000000000 +1000
@@ -477,8 +477,8 @@ static void error(mddev_t *mddev, mdk_rd
 
 	if (!rdev->faulty) {
 		mddev->sb_dirty = 1;
-		conf->working_disks--;
 		if (rdev->in_sync) {
+			conf->working_disks--;
 			mddev->degraded++;
 			conf->failed_disks++;
 			rdev->in_sync = 0;

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-08-30 14:43:27.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-09-01 10:17:46.000000000 +1000
@@ -498,8 +498,8 @@ static void error(mddev_t *mddev, mdk_rd
 
 	if (!rdev->faulty) {
 		mddev->sb_dirty = 1;
-		conf->working_disks--;
 		if (rdev->in_sync) {
+			conf->working_disks--;
 			mddev->degraded++;
 			conf->failed_disks++;
 			rdev->in_sync = 0;
