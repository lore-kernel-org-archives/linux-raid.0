From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Subject: Re: [RFC] MD: Restart an interrupted incremental recovery.
Date: Wed, 12 Oct 2011 19:04:57 -0400
Message-ID: <CANz0V+7ZGKvyznbU_5d2cQm2XL=Wf9B8+HwZZ9KeZSfuawtyOg@mail.gmail.com>
References: <1318448495-8981-1-git-send-email-andreiw@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1318448495-8981-1-git-send-email-andreiw@vmware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Warkentin <andreiw@vmware.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

2011/10/12 Andrei Warkentin <andreiw@vmware.com>:
> If an incremental recovery was interrupted, a subsequent
> re-add will result in a full recovery, even though an
> incremental should be possible.
>
> This patch handles 99% of possible interruptions of an
> incremental recovery (it doesn't handle I/O failure
> that occurs immediately after the hot_add_disk(), which
> causes the added rdev to become a spare).
>
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
> ---

Here is an alternative idea, that doesn't involve messing with the
superblocks - don't write out SB for recovering device (undergoing
incremental) until array is not degraded.

A
