From: Andre Noll <maan@systemlinux.org>
Subject: Re: mdadm-2.3.1 fails to hotadd device
Date: Sun, 26 Feb 2006 15:37:58 +0100
Message-ID: <20060226143758.GL7030@skl-net.de>
References: <20060226110859.GJ7030@skl-net.de> <17409.37867.588055.108823@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17409.37867.588055.108823@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22:41, Neil Brown wrote:
> On Sunday February 26, maan@systemlinux.org wrote:
> > # uname -r; mdadm -V; cat /proc/mdstat 
> > 2.6.15.4-gbbde1285
> > mdadm - v2.3.1 - 6 February 2006
> > Personalities : [raid1] [raid5] [raid6] 
> > md1 : active raid1 hdd1[12] sdi1[8] sda1[0] hda1[13] sdl1[11] sdk1[10]
> > sdj1[9] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
> > 251776 blocks [14/14] [UUUUUUUUUUUUUU]
> 
> You have a 14 drive raid1... cool....
> 
> > # 
> > # mdadm /dev/md1 -a /dev/hdd1
> > mdadm: cannot find valid superblock in this array - HELP

I took another look and added some fprintf's to Manage.c and util.c,
see the patch below. The problem appears to be map_dev() always
returning NULL because devlist is NULL.

With the patch applied, "mdadm /dev/md1 -a /dev/hdd1" gives me
the following output:

mdadm: st->maxdevs = 27
mdadm: major/minor/state: 8/1/6
devlist: (nil)
mdadm: major/minor/state: 8/17/6
devlist: (nil)
mdadm: major/minor/state: 8/33/6
devlist: (nil)
mdadm: major/minor/state: 8/49/6
devlist: (nil)
mdadm: major/minor/state: 8/65/6
devlist: (nil)
mdadm: major/minor/state: 8/81/6
devlist: (nil)
mdadm: major/minor/state: 8/97/6
devlist: (nil)
mdadm: major/minor/state: 8/113/6
devlist: (nil)
mdadm: major/minor/state: 8/129/6
devlist: (nil)
mdadm: major/minor/state: 8/145/6
devlist: (nil)
mdadm: major/minor/state: 8/161/6
devlist: (nil)
mdadm: major/minor/state: 8/177/6
devlist: (nil)
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 3/1/6
devlist: (nil)
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: major/minor/state: 0/0/8
mdadm: cannot find valid superblock in this array - HELP

---

diff -urpN mdadm-2.3.1/Manage.c mdadm-2.3.1-hacked/Manage.c
--- mdadm-2.3.1/Manage.c	Mon Dec  5 05:52:22 2005
+++ mdadm-2.3.1-hacked/Manage.c	Sun Feb 26 14:13:07 2006
@@ -236,6 +236,7 @@ int Manage_subdevs(char *devname, int fd
 
 			if (array.not_persistent == 0) {
 
+				fprintf(stderr, Name ": st->maxdevs = %d\n", st->max_devs);
 				/* need to find a sample superblock to copy, and
 				 * a spare slot to use 
 				 */
@@ -245,6 +246,7 @@ int Manage_subdevs(char *devname, int fd
 					disc.number = j;
 					if (ioctl(fd, GET_DISK_INFO, &disc))
 						continue;
+					fprintf(stderr, Name ": major/minor/state: %d/%d/%d\n", disc.major, disc.minor, disc.state);
 					if (disc.major==0 && disc.minor==0)
 						continue;
 					if ((disc.state & 4)==0) continue; /* sync */
diff -urpN mdadm-2.3.1/util.c mdadm-2.3.1-hacked/util.c
--- mdadm-2.3.1/util.c	Tue Jan 31 00:43:03 2006
+++ mdadm-2.3.1-hacked/util.c	Sun Feb 26 14:06:51 2006
@@ -412,6 +412,7 @@ char *map_dev(int major, int minor)
 		devlist_ready=1;
 	}
 
+	fprintf(stderr, "devlist: %p\n", devlist);
 	for (p=devlist; p; p=p->next)
 		if (p->major == major &&
 		    p->minor == minor) {
-- 
The only person who always got his work done by Friday was Robinson Crusoe
