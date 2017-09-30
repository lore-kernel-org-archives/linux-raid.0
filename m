From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
 without
Date: Sat, 30 Sep 2017 17:46:58 +0800
Message-ID: <f5b2cb91-3a9e-69ba-6b01-51335ec74da1@redhat.com>
References: <150518076229.32691.13542756562323866921.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150518076229.32691.13542756562323866921.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 09/12/2017 09:49 AM, NeilBrown wrote:
> Hi,
>   I looked again at the previous patch I posted which tried to mak
>   md_update_sb() safe without taking reconfig_mutex, and realized that
>   it had serious problems, particularly around devices being added or
>   removed while the update was happening.
Could you explain this in detail? What's the serious problems?

Regards
Xiao
>
>   So I decided to try a different approach, which is embodied in these
>   patches.  The md thread is now explicitly allowed to call
>   md_update_sb() while some other thread holds the lock and
>   waits for mddev_suspend() to complete.
>
>   Please test these and confirm that they still address the problem you
>   found.
>
> Thanks,
> NeilBrown
>
> ---
>
> NeilBrown (4):
>        md: always hold reconfig_mutex when calling mddev_suspend()
>        md: don't call bitmap_create() while array is quiesced.
>        md: use mddev_suspend/resume instead of ->quiesce()
>        md: allow metadata update while suspending.
>
>
>   drivers/md/dm-raid.c     |    5 ++++-
>   drivers/md/md.c          |   45 ++++++++++++++++++++++++++++++++-------------
>   drivers/md/md.h          |    6 ++++++
>   drivers/md/raid5-cache.c |    2 ++
>   4 files changed, 44 insertions(+), 14 deletions(-)
>
> --
> Signature
>

