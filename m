From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1: no resync after crash?
Date: Tue, 22 Mar 2005 09:48:47 +1100
Message-ID: <16959.20303.387995.832203@cse.unsw.edu.au>
References: <d1ejor$9j7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Mario Holbe on Friday March 18
Sender: linux-raid-owner@vger.kernel.org
To: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 18, Mario.Holbe@TU-Ilmenau.DE wrote:
> 
> Is there perhaps some bug that denies a resync on a degraded
> RAID1 even if there is more than one mirror operational?
> 

Yes :-(

The following patch might fix it...
I guess I should double check and submit something to Marcelo. 
Thanks for reporting this.

NeilBrown


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-08-16 10:17:11.000000000 +1000
+++ ./drivers/md/raid1.c	2005-03-22 09:47:11.000000000 +1100
@@ -1737,10 +1737,11 @@ static int raid1_run (mddev_t *mddev)
 		}
 	}
 
-	if (!start_recovery && !(sb->state & (1 << MD_SB_CLEAN)) &&
+	if (!(sb->state & (1 << MD_SB_CLEAN)) &&
 	    (conf->working_disks > 1)) {
 		const char * name = "raid1syncd";
 
+		start_recovery = 0;
 		conf->resync_thread = md_register_thread(raid1syncd, conf,name);
 		if (!conf->resync_thread) {
 			printk(THREAD_ERROR, mdidx(mddev));
