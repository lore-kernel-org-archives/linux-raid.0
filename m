From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [mdadm PATCH] mdopen: open md devices O_RDONLY
Date: Mon, 05 Dec 2016 09:26:42 -0500
Message-ID: <wrfjfum2bgf1.fsf@redhat.com>
References: <87eg1m6gco.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eg1m6gco.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 05 Dec 2016 17:27:03 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Marc Smith <marc.smith@mcc.edu>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> There is no need to request write access when opening
> the md device, as we never write to it, and none of the
> ioctls we use require write access.
>
> If we do open with write access, then when we close, udev notices that
> the device was closed after being open for write access, and it
> generates a CHANGE event.
>
> This is generally unwanted, and particularly problematic when mdadm is
> trying to --stop the array, as the CHANGE event can cause the array to
> be re-opened before it completely closed, which results in a new mddev
> being allocated.
>
> So just use O_RDONLY instead of O_RDWR.
>
> Reported-by: Marc Smith <marc.smith@mcc.edu>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  mdassemble.c | 2 +-
>  mdopen.c     | 4 +---
>  2 files changed, 2 insertions(+), 4 deletions(-)

Applied!

Thanks,
Jes
