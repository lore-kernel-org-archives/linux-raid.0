From: jes.sorensen@gmail.com
Subject: Re: [mdadm PATCH] Retry HOT_REMOVE_DISK a few times.
Date: Tue, 28 Mar 2017 14:26:08 -0400
Message-ID: <wrfjmvc5febj.fsf@gmail.com>
References: <87d1d38p47.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1d38p47.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 27 Mar 2017 12:50:16 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> HOT_REMOVE_DISK can fail with EBUSY if there are outstanding
> IO request that have not completed yet.  It can sometimes
> be helpful to wait a little while for these to complete.
>
> We already do this in impose_level() when reshaping a device,
> but not in Manage.c in response to an explicit --remove request.
>
> So create hot_remove_disk() to central this code, and call it
> where-ever it makes sense to wait for a HOT_REMOVE_DISK to succeed.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Grow.c   |  9 +--------
>  Manage.c |  4 ++--
>  mdadm.h  |  1 +
>  util.c   | 18 ++++++++++++++++++
>  4 files changed, 22 insertions(+), 10 deletions(-)

Applied!

Thanks,
Jes
