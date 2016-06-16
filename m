From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] MDADM:Check mdinfo->reshape_active more times before calling Grow_continue
Date: Thu, 16 Jun 2016 13:54:08 -0400
Message-ID: <wrfjporhow8v.fsf@redhat.com>
References: <1466041262-12785-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1466041262-12785-1-git-send-email-xni@redhat.com> (Xiao Ni's
	message of "Thu, 16 Jun 2016 09:41:02 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> When reshaping a 3 drives raid5 to 4 drives raid5, there is a chance that
> it can't start the reshape. If the disks are not enough to have spaces for
> relocating the data_offset, it needs to call start_reshape and then run 
> mdadm --grow --continue by systemd. But mdadm --grow --continue fails 
> because it checkes that info->reshape_active is 0. 
>
> The info->reshape_active is got from the superblock of underlying devices.
> Function start_reshape write reshape to /sys/../sync_action. Before writing
> latest superblock to underlying devices, mdadm --grow --continue is called.
> There is a chance info->reshape_active is 0. We should wait for superblock
> updating more time before calling Grow_continue.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c | 67 ++++++++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 37 insertions(+), 30 deletions(-)

Applied!

Thanks,
Jes
