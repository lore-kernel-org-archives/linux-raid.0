From: Neil Brown <neilb@suse.de>
Subject: Re: Reshaping raid0/10
Date: Mon, 12 Mar 2007 09:36:39 +1100
Message-ID: <17908.33911.135761.236374@notabene.brown>
References: <Pine.LNX.4.61.0702211726500.12039@yvahk01.tjqt.qr>
	<17884.42154.248251.261955@notabene.brown>
	<Pine.LNX.4.61.0702231357420.9736@yvahk01.tjqt.qr>
	<17887.19400.179239.281711@notabene.brown>
	<45F3134C.7070500@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from H. Peter Anvin on Saturday March 10
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday March 10, hpa@zytor.com wrote:
> Neil Brown wrote:
> > 
> > If I wanted to reshape a raid0, I would just morph it into a raid4
> > with a missing parity drive, then use the raid5 code to restripe it.
> > Then morph it back to regular raid0.
> > 
> 
> Wow, that made my brain hurt.
> 
> Given the fact that we're going to have to do this on kernel.org soon, 
> what would be the concrete steps involved (we're going to have to change 
> 3-member raid0 into 4-member raid0)...

Well.... it's not straight forward at all.

Firstly: it can only work if all your drives are the same size
(rounded to 64K).  If they aren't raid0 will use all the available
space on each drive, while raid5 will only use the amount that is
available on the first drive.

If that condition is met, then you can safely convert to a raid4 with
one extra (missing) device by simply creating an array with the same
drives (so you have to stop and restart the array - you cannot do that
bit while the array is live).  You seem to need --assume-clean
to create the raid4 degraded... That is probably a bug in mdadm.

md/raid5 won't grow a degraded array, so now you have to add the new
drive and let it sync the parity information onto it even though you
aren't going to ultimately use it.  This is a bit of a bore.  It could
probably be fixed but it wouldn't be entirely trivial (meaning a day
rather than an hour).

Once you have the non-degraded raid4, the next step would be
  mdadm -G /dev/mdX -n 5 --backup-file=/root/something
(a 5 drive raid4 contains your 4drive raid0).  Growing to a degraded
array is not a problem.  However md won't currently let you do this
on a raid4.   The patch to fix this is trivial and is below.

The --backup-file is needed as there is no spare for mdadm to store
some temporary data on.

Once the grow finishes, you can unmount, stop the array, and create it
as a raid0.

This seems to work - I just tried it on a rather small filesystem
(100M per drive) and it all went quite smoothly.

I hope to be able to get all this automated one days so you can just
  mdadm -G /dev/mdX -n 4
on a raid0 and it will work.

The need to sync the new disk first adds some real awkwardnesses.  It
would actually be a lot easier if the parity device was the first of
the array instead of the last.. retro fitting a new raid4 layout which
you cannot accidentally corrupt be using an old kernel might be
awkward though... not impossible.

Changing a raid0 to a raid4 while on-line is also non-trivial.  Raid0
doesn't keep track of requests-in-flight so knowing when all raid0
requests have completed and it is ok to start handling requests via
raid4 will need some care..

But with the following patch and a small down-time window at each end,
you can use md to grow a raid0 today...  But I suggest you try it on
test data first.

NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-03-02 15:48:35.000000000 +1100
+++ ./drivers/md/raid5.c	2007-03-12 09:02:41.000000000 +1100
@@ -4104,6 +4104,10 @@ static struct mdk_personality raid4_pers
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+#ifdef CONFIG_MD_RAID5_RESHAPE
+	.check_reshape	= raid5_check_reshape,
+	.start_reshape  = raid5_start_reshape,
+#endif
 	.quiesce	= raid5_quiesce,
 };
 
