From: jes.sorensen@gmail.com
Subject: Re: [PATCH] mdadm:check the nodes when operate clustered array
Date: Mon, 06 Mar 2017 16:28:46 -0500
Message-ID: <wrfj4lz6m6wh.fsf@gmail.com>
References: <1488364953-20456-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488364953-20456-1-git-send-email-zlliu@suse.com> (Zhilong Liu's
        message of "Wed, 1 Mar 2017 18:42:33 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> It doesn't make sense to write_bitmap with less than 2 nodes,
> in order to avoid 'write_bitmap' received invalid nodes number,
> it would be better to do checking nodes in getopt operations.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
> such as following method would reproduce the issue.
> # mdadm -CR /dev/md0 -l1 -n2 --bitmap=internal /dev/sda /dev/sdb
> # mdadm --grow /dev/md0 --bitmap=none
> # mdadm --grow /dev/md0 --bitmap=clustered --nodes=1
> # mdadm -X /dev/sda, it would be written internal bitmap.

Applied!

Thanks,
Jes
