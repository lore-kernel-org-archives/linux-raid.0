From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] MDADM:Check mdinfo->reshape_active more times before calling Grow_continue
Date: Wed, 15 Jun 2016 16:27:22 -0400
Message-ID: <wrfjk2hqtcyd.fsf@redhat.com>
References: <1465955832-3781-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1465955832-3781-1-git-send-email-xni@redhat.com> (Xiao Ni's
	message of "Wed, 15 Jun 2016 09:57:12 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> Hi Jes
>
> Thanks for reminding me. This is the patch after modifying. 
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

Xiao,

Sorry but this version doesn't compile:

Grow.c: In function 'Grow_continue_command':
Grow.c:4838:12: error: 'cnt' undeclared (first use in this function)
   } while (cnt-- > 0);
            ^

Also please try to separate the email comments from the patch message. I
normally save the message and use git am to integrate it.

Thanks,
Jes
