From: Neil Brown <neilb@suse.de>
Subject: Re: Recovery speed at 1MB/s/device, unable to change
Date: Mon, 24 Apr 2006 07:58:44 +1000
Message-ID: <17483.63636.745420.456281@cse.unsw.edu.au>
References: <444BD3E7.4090601@gmail.com>
	<444BF3AC.4090804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Anssi Hannula on Monday April 24
Sender: linux-raid-owner@vger.kernel.org
To: Anssi Hannula <anssi.hannula@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 24, anssi.hannula@gmail.com wrote:
> # mdadm --grow /dev/md_d1 --raid-devices=3 --backup-file backupfile
> mdadm: Need to backup 128K of critical section..
> mdadm: /dev/md_d1: Cannot get array details from sysfs
> 
> Strace shows that it's trying to access
> "/sys/block/md_d4/md/component_size".
> 
> Why is this?

Because I didn't test my code properly :-(

Following patch should fix it.

Re: the recovery speed problem:  I would try dding from one drive to
the other and see what sort of speed you get then:
  dd if=/dev/sda of=/dev/sdb bs=1024k count=1000
or something like that.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./sysfs.c~current~ ./sysfs.c
--- ./sysfs.c~current~	2006-03-14 15:33:12.000000000 +1100
+++ ./sysfs.c	2006-04-24 07:56:56.000000000 +1000
@@ -206,7 +206,7 @@ unsigned long long get_component_size(in
 			minor(stb.st_rdev));
 	else
 		sprintf(fname, "/sys/block/md_d%d/md/component_size",
-			minor(stb.st_rdev)/16);
+			minor(stb.st_rdev)/64);
 	fd = open(fname, O_RDONLY);
 	if (fd < 0)
 		return 0;
