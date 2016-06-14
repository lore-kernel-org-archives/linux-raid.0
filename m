From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] MDADM:Check mdinfo->reshape_active more times before calling Grow_continue
Date: Tue, 14 Jun 2016 14:34:09 -0400
Message-ID: <wrfjbn33ei1q.fsf@redhat.com>
References: <1465722945-9073-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1465722945-9073-1-git-send-email-xni@redhat.com> (Xiao Ni's
	message of "Sun, 12 Jun 2016 17:15:45 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> Hi 
>
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
> Regards
> Xiao

Hi Xiao,

Looks reasonable to retry before giving up.

Unfortunately your patch has some whitespace issues at the end, using
spaces instead of tabs, and lacks a signed-off-by line.

Would you mind fixing it up and resubmitting it?

Thanks,
Jes
