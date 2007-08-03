From: Neil Brown <neilb@suse.de>
Subject: Re: Need clarification on raid1 resync behavior with bitmap support
Date: Fri, 3 Aug 2007 16:42:48 +1000
Message-ID: <18098.52840.936611.7816@notabene.brown>
References: <170fa0d20707210959q11153d38u3281062c98d3adb7@mail.gmail.com>
	<18084.22271.122052.80056@notabene.brown>
	<170fa0d20707230547y3accc5c9v14805fdb3637e9c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Monday July 23
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 23, snitzer@gmail.com wrote:
> On 7/23/07, Neil Brown <neilb@suse.de> wrote:
> > Can you test this out and report a sequence of events that causes a
> > full resync?
> 
> Sure, using an internal-bitmap-enabled raid1 with 2 loopback devices
> on a stock 2.6.20.1 kernel, the following sequences result in a full
> resync.  (FYI, I'm fairly certain I've seen this same behavior on
> 2.6.18 and 2.6.15 kernels too but would need to retest):
> 
> 1)
> mdadm /dev/md0 --manage --fail /dev/loop0
> mdadm -S /dev/md0
> mdadm --assemble /dev/md0 /dev/loop0 /dev/loop1
>   mdadm: /dev/md0 has been started with 1 drive (out of 2).
>   NOTE: kernel log says:  md: kicking non-fresh loop0 from array!
> mdadm /dev/md0 --manage --re-add /dev/loop0


sorry for the slow response.

It looks like commit 1757128438d41670ded8bc3bc735325cc07dc8f9
(December 2006) set conf->fullsync a litte too often.

This seems to fix it, and I'm fairly sure it is correct.

Thanks,
NeilBrown

----------------------------------
Make sure a re-add after a restart honours bitmap when resyncing.

Commit 1757128438d41670ded8bc3bc735325cc07dc8f9 was slightly bad.
If and array has a write-intent bitmap, and you remove a drive,
then readd it, only the changes parts should be resynced.
This only works if the array has not been shut down and restarted.

The above mentioned commit sets 'fullsync' at little more often
than it should.  This patch is more careful.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-07-31 11:21:29.000000000 +1000
+++ ./drivers/md/raid1.c	2007-08-03 16:24:23.000000000 +1000
@@ -1918,7 +1918,8 @@ static int run(mddev_t *mddev)
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
-			conf->fullsync = 1;
+			if (disk->rdev)
+				conf->fullsync = 1;
 		}
 	}
 	if (mddev->degraded == conf->raid_disks) {
