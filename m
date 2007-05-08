From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux MD Raid Bug(?) w/Kernel sync_speed_min Option
Date: Tue, 8 May 2007 09:24:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705080920050.3619@p34.internal.lan>
References: <Pine.LNX.4.64.0705080821350.16228@p34.internal.lan>
 <17984.29974.116526.922404@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17984.29974.116526.922404@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 8 May 2007, Neil Brown wrote:

> On Tuesday May 8, jpiszcz@lucidpixels.com wrote:
>
> This patch might help though.  Let me know if it does what you expect.
>
> Thanks,
> NeilBrown
>
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
> ./drivers/md/md.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff .prev/drivers/md/md.c ./drivers/md/md.c
> --- .prev/drivers/md/md.c	2007-05-07 17:47:15.000000000 +1000
> +++ ./drivers/md/md.c	2007-05-08 22:57:51.000000000 +1000
> @@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
> 		 *
> 		 * Note: the following is an unsigned comparison.
> 		 */
> -		if ((curr_events - rdev->last_events + 4096) > 8192) {
> +		if ((long)curr_events - (long)rdev->last_events > 8192) {
> 			rdev->last_events = curr_events;
> 			idle = 0;
> 		}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Neil, awesome patch-- what are the chances of it getting merged into 
2.6.22?

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] 
sde1[
2] sdd1[1] sdc1[0]
       1318686336 blocks level 5, 128k chunk, algorithm 2 [10/10] 
[UUUUUUUUUU]
       [>....................]  check =  0.5% (854084/146520704) 
finish=42.6min speed=56938K/sec

md0 : active raid1 sdb1[1] sda1[0]
       16787776 blocks [2/2] [UU]
       [=>...................]  check =  7.5% (1265984/16787776) 
finish=3.6min speed=70332K/sec

$ cat /sys/block/md2/md/sync_speed_min
1000 (system)

$ cat /sys/block/md3/md/sync_speed_min
1000 (system)

Working as advertised (utilizing all idle I/O)!

Justin.


