From: jes.sorensen@gmail.com
Subject: Re: [mdadm PATCH 5/5] Detail: handle non-existent arrays better.
Date: Tue, 28 Mar 2017 14:34:07 -0400
Message-ID: <wrfj60itfdy8.fsf@gmail.com>
References: <149058575542.15679.9804611071393072863.stgit@noble>
        <149058581623.15679.14330532500949622569.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149058581623.15679.14330532500949622569.stgit@noble>
        (NeilBrown's message of "Mon, 27 Mar 2017 14:36:56 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> If you call "mdadm --detail" with a device file for an array which
> doesn't exist, such as by
>   mknod /dev/md57 b 9 57
>   mdadm --detail /dev/md57
>
> you get an unhelpful message about and inactive RAID0, and return
> status is '0'.  This is confusing.
>
> So catch this possibility and print a more useful message, and
> return a non-zero status.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Detail.c |    8 ++++++++
>  1 file changed, 8 insertions(+)

Applied!

Thanks,
Jes
