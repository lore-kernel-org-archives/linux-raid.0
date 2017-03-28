From: jes.sorensen@gmail.com
Subject: Re: [mdadm PATCH 3/5] Introduce sys_hot_remove_disk()
Date: Tue, 28 Mar 2017 14:33:08 -0400
Message-ID: <wrfjefxhfdzv.fsf@gmail.com>
References: <149058575542.15679.9804611071393072863.stgit@noble>
        <149058581585.15679.12535145868752526948.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149058581585.15679.12535145868752526948.stgit@noble>
        (NeilBrown's message of "Mon, 27 Mar 2017 14:36:56 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> The new hot_remove_disk() will retry HOT_REMOVE_DISK
> several times in the face of EBUSY.
> However we sometimes remove a device by writing "remove" to the
> "state" attributed.  This should be retried as well.
> So introduce sys_hot_remove_disk() to repeat this action a few times.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Manage.c |    6 +-----
>  mdadm.h  |    1 +
>  util.c   |   12 ++++++++++++
>  3 files changed, 14 insertions(+), 5 deletions(-)

Applied!

Thanks,
Jes
