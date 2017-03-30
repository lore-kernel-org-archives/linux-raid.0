From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v1] mdadm/grow: reshape would be stuck from raid1 to raid5
Date: Thu, 30 Mar 2017 11:50:24 -0400
Message-ID: <07299461-6f67-710a-fcb6-45b74e5d856d@gmail.com>
References: <wrfjk27aid6n.fsf@gmail.com>
 <20170330073808.6176-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170330073808.6176-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/30/2017 03:38 AM, Zhilong Liu wrote:
> systemctl doesn't interpret mdadm-grow-continue@.service
> correctly due to the wrong argument provided in [service],
> it should be corrected %I as %i. Otherwise, if the service
> cannot start by systemctl and the reshap progress would be
> stuck all time when grows array from raid1 to raid5.
>
> reproduce steps:
> ./mdadm -CR /dev/md0 -l1 -b internal -n2 /dev/loop[0-1]
> ./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  systemd/mdadm-grow-continue@.service | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This solution looks more correct to me :)

Applied!

Thanks,
Jes


