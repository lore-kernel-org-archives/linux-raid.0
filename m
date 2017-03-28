From: jes.sorensen@gmail.com
Subject: Re: [mdadm PATCH 4/5] Add 'force' flag to *hot_remove_disk().
Date: Tue, 28 Mar 2017 14:33:18 -0400
Message-ID: <wrfja885fdzl.fsf@gmail.com>
References: <149058575542.15679.9804611071393072863.stgit@noble>
        <149058581604.15679.9993360149817038150.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149058581604.15679.9993360149817038150.stgit@noble> (NeilBrown's
        message of "Mon, 27 Mar 2017 14:36:56 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> In rare circumstances, the short period that *hot_remove_disk()
> waits isn't long enough to IO to complete.  This particularly happens
> when a device is failing and many retries are still happening.
>
> We don't want to increase the normal wait time for "mdadm --remove"
> as that might be use just to test if a device is active or not, and a
> delay would be problematic.
> So allow "--force" to mean that mdadm should try extra hard for a
> --remove to complete, waiting up to 5 seconds.
>
> Note that this patch fixes a comment which claim the previous
> wait time was half a second, where it was really 50msec.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Grow.c   |    2 +-
>  Manage.c |   10 +++++-----
>  mdadm.h  |    4 ++--
>  util.c   |   10 +++++-----
>  4 files changed, 13 insertions(+), 13 deletions(-)

Applied!

Thanks,
Jes
