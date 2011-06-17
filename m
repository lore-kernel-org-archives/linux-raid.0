From: James Paradis <jparadis@redhat.com>
Subject: Re: [PATCH/RFC] Fix resync hang after surprise removal
Date: Fri, 17 Jun 2011 11:42:19 -0400 (EDT)
Message-ID: <4770908.772445.1308325339109.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>
References: <20110616113656.190fef9f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110616113656.190fef9f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> NeilBrown <neilb@suse.de> wrote:
> Hi,
> thanks for the report and the patch.
> 
> However I don't think the patch really does what you want.
> 
> The two tests are already mutually exclusive as one begins with
> raid_disk >= 0
> and the other with
> raid_disk < 0
> and neither change raid_disk.
> 
> The reason the patch has an effect is the 'break' that has been added.
> i.e. as soon as you find a normal working device you break out of the
> loop
> and stop looking for spares.
> 
> I think the correct fix is simply:
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4332fc2..91e31e2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7088,6 +7088,7 @@ static int remove_and_add_spares(mddev_t *mddev)
> list_for_each_entry(rdev, &mddev->disks, same_set) {
> if (rdev->raid_disk >= 0 &&
> !test_bit(In_sync, &rdev->flags) &&
> + !test_bit(Faulty, &rdev->flags) &&
> !test_bit(Blocked, &rdev->flags))
> spares++;
> if (rdev->raid_disk < 0
> 
> 
> i.e. never consider a Faulty device to be a spare.
> 
> It looks like this bug was introduced by commit dfc70645000616777
> in 2.6.26 when we allowed partially recovered devices to remain in the
> array
> when a different device fails.
> 
> Can you please conform that this patch removes your symptom?
> 
> Thanks,
> NeilBrown

This patch does indeed fix the problem!  Thanks!

--jim

