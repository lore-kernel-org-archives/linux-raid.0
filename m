From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Fix bug where new drives added to an md array sometimes
 don't sync properly.
Date: Tue, 10 Oct 2006 12:00:26 +1000
Message-ID: <17706.65210.999441.373846@cse.unsw.edu.au>
References: <20061005171233.6542.patches@notabene>
	<1061005071326.6578@suse.de>
	<45255C54.6060608@ilm.com>
	<4526DBCE.6070906@ilm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eli Stair on Friday October 6
Sender: linux-raid-owner@vger.kernel.org
To: Eli Stair <estair@ilm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 6, estair@ilm.com wrote:
> 
> This patch has resolved the immediate issue I was having on 2.6.18 with 
> RAID10.  Previous to this change, after removing a device from the array 
> (with mdadm --remove), physically pulling the device and 
> changing/re-inserting, the "Number" of the new device would be 
> incremented on top of the highest-present device in the array.  Now, it 
> resumes its previous place.
> 
> Does this look to be 'correct' output for a 14-drive array, which dev 8 
> was failed/removed from then "add"'ed?  I'm trying to determine why the 
> device doesn't get pulled back into the active configuration and 
> re-synced.  Any comments?

Does this patch help?



Fix count of degraded drives in raid10.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2006-10-09 14:18:00.000000000 +1000
+++ ./drivers/md/raid10.c	2006-10-05 20:10:07.000000000 +1000
@@ -2079,7 +2079,7 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + i;
 
 		if (!disk->rdev ||
-		    !test_bit(In_sync, &rdev->flags)) {
+		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
 		}


NeilBrown
