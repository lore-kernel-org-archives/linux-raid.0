From: Neil Brown <neilb@suse.de>
Subject: Re: Can't get md array to shut down cleanly
Date: Fri, 7 Jul 2006 08:13:02 +1000
Message-ID: <17581.35566.273512.814844@cse.unsw.edu.au>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christian Pernegger on Thursday July 6
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 6, pernegger@gmail.com wrote:
> Still more problems ... :(
> 
> My md raid5 still does not always shut down cleanly. The last few
> lines of the shutdown sequence are always as follows:
> 
> [...]
> Will now halt.
> md: stopping all md devices.
> md: md0 still in use.
> Synchronizing SCSI cache for disk /dev/sdd:
> Synchronizing SCSI cache for disk /dev/sdc:
> Synchronizing SCSI cache for disk /dev/sdb:
> Synchronizing SCSI cache for disk /dev/sda:
> Shutdown: hde
> System halted.
> 
> Most of the time the md array comes up clean on the next boot, often
> enough it does not. Having the array rebuild after every other reboot
> is not my idea of fun, because the only reason to take it down is to
> exchange a failing disk.
> 

How are you shutting down the machine?  If something sending SIGKILL
to all processes?  If it does, then md really should shut down cleanly
every time....

That said, I do see some room for improvement in the md shutdown
sequence - it shouldn't give up at that point just because the device
seems to be in use....  I'll look into that.
You could try the following patch.  I think it should be safe.

NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-07-07 08:11:43.000000000 +1000
+++ ./drivers/md/md.c	2006-07-07 08:12:15.000000000 +1000
@@ -3217,7 +3217,7 @@ static int do_md_stop(mddev_t * mddev, i
 	struct gendisk *disk = mddev->gendisk;
 
 	if (mddev->pers) {
-		if (atomic_read(&mddev->active)>2) {
+		if (mode != 1 && atomic_read(&mddev->active)>2) {
 			printk("md: %s still in use.\n",mdname(mddev));
 			return -EBUSY;
 		}
