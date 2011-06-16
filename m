From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH/RFC] Fix resync hang after surprise removal
Date: Thu, 16 Jun 2011 11:36:56 +1000
Message-ID: <20110616113656.190fef9f@notabene.brown>
References: <20110615160117.31326.31562.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110615160117.31326.31562.sendpatchset@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Paradis <jparadis@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Jun 2011 12:02:15 -0400 Jim Paradis <jparadis@redhat.com> wrote:

> We ran into a situation where surprise removal of a non-boot 2-disk raid1
> array with I/O running can result in a tight loop in which md claims to be
> resyncing the array.
> 
> It appears that remove_add_spares() in md.c contains two sets of conditions
> used to determine if there is a spare available.  The disk that was pulled
> has been marked 'faulty' in rdev->flags and its raid_disk value is >= 0.
> Since it is neither In_Sync nor Blocked, spares gets incremented and so md
> thinks there is a spare when in fact there is not.
> 
> One of my colleagues at Stratus proposed this patch, which rearranges the
> order of the tests and makes them mutually exclusive.  Running with this
> patch resolves the problem in our lab: we were able to run stress tests
> with surprise removals without incident.
> 
> Since neither of us is an md expert, we'd like feedback as to whether
> this patch is reasonable and whether it can be pushed upstream.

Hi,
 thanks for the report and the patch.

 However I don't think the patch really does what you want.

 The two tests are already mutually exclusive as one begins with
      raid_disk >= 0
 and the other with
      raid_disk < 0
 and neither change raid_disk.

 The reason the patch has an effect is the 'break' that has been added.
 i.e. as soon as you find a normal working device you break out of the loop
 and stop looking for spares.

 I think the correct fix is simply:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4332fc2..91e31e2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7088,6 +7088,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(Blocked, &rdev->flags))
 				spares++;
 			if (rdev->raid_disk < 0


i.e. never consider a Faulty device to be a spare.

It looks like this bug was introduced by commit dfc70645000616777
in 2.6.26 when we allowed partially recovered devices to remain in the array
when a different device fails.

Can you please conform that this patch removes your symptom?

Thanks,
NeilBrown

