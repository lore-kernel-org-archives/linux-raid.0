From: Neil Brown <neilb@suse.de>
Subject: Re: converting RAID5 to RAID10
Date: Thu, 5 Oct 2006 20:14:42 +1000
Message-ID: <17700.56082.745304.937160@cse.unsw.edu.au>
References: <20061005095913.GA2530@piper.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from martin f krafft on Thursday October 5
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday October 5, madduck@madduck.net wrote:
> 
> Unfortunately, mdadm (2.5.3) doesn't seem to agree; it complains
> that it cannot assemble a RAID10 with 4 devices when I ask it to:
> 
>   mdadm --create -l 10 -n4 -pn2 /dev/md1 /dev/sd[cd] missing missing
> 

mdadm --create -l 10 -n 4 -pn2 /dev/md1 /dev/sdc missing /dev/sdd missing

Raid10 lays out data like
  A A B B
  C C D D
not
  A B A B
  C D C D
as you seem to expect.

So you could even do

mdadm --create -l 10 -n 4 -pn2 /dev/md1 missing /dev/sd[cd] missing

for slightly less typing.

There seems to be a bug in raid10 that is reports the wrong number of
working drives.  This is probably only in 2.6.18.  Patch is below.

NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2006-09-29 11:44:36.000000000 +1000
+++ ./drivers/md/raid10.c	2006-10-05 20:10:07.000000000 +1000
@@ -2079,7 +2079,7 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + i;
 
 		if (!disk->rdev ||
-		    !test_bit(In_sync, &rdev->flags)) {
+		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
 		}
