From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: Raid0 Reshape . Preface
Date: Wed, 17 Jun 2009 21:55:00 +1000
Message-ID: <19000.55700.831349.967378@notabene.brown>
References: <1245189072.3478.92.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Wednesday June 17
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday June 17, raziebe@gmail.com wrote:
> Neil Hello
> This email is followed by a set of the raid0 reshape patches for your inspection.
> hopefully i haven't mess anything in this set.

Hi Raz,

 I've had a bit of a look and while it would need a few refinements it
 seems to generally make sense - though there are a lot of details I
 haven't looked at thoroughly yet.

 However... I'm not at all sure I want to continue with this
 direction.

 The more I think about it, the more I feel I would prefer to use the
 raid5 module for all restriping.
 So to reshape a raid0, we would convert it to degraded-raid4, reshape
 that, then convert back to raid0.

 I would really like to keep the raid0 module very simple and clean.

 For the above to work, the most significant changes that would be
 needed to raid5 are:

  1/ add multi-zone support for raid4.
     Much of the complexity of this would be in init_stripe
     (to set sh->disks and the various sh->dev[].)
     and raid5_compute_sector (to choose the correct stripe).

  2/ add non-power-of-2 chunks support.
     We already use sector_div quite a lot, so this probably isn't
     a big problem.

  3/ Record the size of each device in the metadata.
     This isn't needed for raid0 as each device records its own size,
     but for raid4, one device might be missing, and we need to know
     how big it is.
     For v0.90 there is room in the superblock to store this
     information.
     For v1.x there isn't - I only allowed 2 bytes per device, and
     we really need another 8.   This is not an insurmountable problem
     as we can add a feature flag to change the size of the per-device
     information from 2 to 16 bytes.

 I would certainly like to see how this approach pans out before
 committing one way or the other.

NeilBrown
