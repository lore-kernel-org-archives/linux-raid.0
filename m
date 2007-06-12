From: Neil Brown <neilb@suse.de>
Subject: Re: spare group
Date: Tue, 12 Jun 2007 19:54:28 +1000
Message-ID: <18030.27988.798462.933425@notabene.brown>
References: <466D51EE.7030509@avaxio.net>
	<18029.57132.285522.284156@notabene.brown>
	<466E3E58.8050105@avaxio.net>
	<18030.17507.290572.911043@notabene.brown>
	<466E5206.20200@avaxio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomka Gergely on Tuesday June 12
Sender: linux-raid-owner@vger.kernel.org
To: tomka@avaxio.net
Cc: "Linux, Raid lista" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday June 12, tomka@avaxio.net wrote:
> 
> I am very sorry, but it wont works with .9 superblocks also :( We 
> missing something small, but important here. Before you start to code. 
> mdadm was running in monitor mode, and reported a Fail. mdadm is the 
> latest version, 2.6.2.
> 
> tg

Hmmm..... 
[tests code]

Yes, you are right.  It looks like a bug was introduced in 2.6 which
broke various aspects of --monitor.  I guess I need to add some
--monitor tests to my regression test suite.

This patch should fix it.

Thanks again,
NeilBrown


-------------------------------
Fix spare migration and other problems with --monitor.

2.6 broke --monitor in various ways, including spare migration
stopped working.  This fixes it.


### Diffstat output
 ./Monitor.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/Monitor.c ./Monitor.c
--- .prev/Monitor.c	2007-02-22 14:59:11.000000000 +1100
+++ ./Monitor.c	2007-06-12 19:48:34.000000000 +1000
@@ -328,6 +328,7 @@ int Monitor(mddev_dev_t devlist,
 			for (i=0; i<MaxDisks && i <= array.raid_disks + array.nr_disks;
 			     i++) {
 				mdu_disk_info_t disc;
+				disc.number = i;
 				if (ioctl(fd, GET_DISK_INFO, &disc) >= 0) {
 					info[i].state = disc.state;
 					info[i].major = disc.major;
