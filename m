From: CoolCold <coolthecold@gmail.com>
Subject: Re: [PATCH] Update documentation for sync_min and sync_max entries
Date: Wed, 11 May 2011 21:11:39 +0400
Message-ID: <BANLkTi=qU-7UX6SGrfLX3wNRUPOKzDSwgg@mail.gmail.com>
References: <AANLkTinEzjxW6ZFkBWYc6UY6Pus1NoY_O+bKyCoDgC6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinEzjxW6ZFkBWYc6UY6Pus1NoY_O+bKyCoDgC6w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

There is orthographical mistake in patch, in word "withing", should be
"within". I guess this is too little for one more emailed patch, so
just notifying & marking line.

On Tue, Mar 15, 2011 at 3:30 PM, CoolCold <coolthecold@gmail.com> wrote=
:
> This patch is against 2.6.37 (
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.g=
it
> , commit id 97b197f07d15dbcd53328e75754e2f947814c733 ) but I didn't
> notice any changes in 2.6.38 though.
>
> linux/Documentation/md.txt is missing description for sync_min and
> sync_max entries.
> This patch adds description for sync_min and sync_max entries.
>
> Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
> ---
> =A0Documentation/md.txt | =A0 10 ++++++++++
> =A01 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/md.txt b/Documentation/md.txt
> index a81c7b4..8f8cb4f 100644
> --- a/Documentation/md.txt
> +++ b/Documentation/md.txt
> @@ -552,6 +552,16 @@ also have
> =A0 =A0 =A0within the array where IO will be blocked. =A0This is curr=
ently
> =A0 =A0 =A0only supported for raid4/5/6.
>
> + =A0 sync_min
> + =A0 sync_max
> + =A0 =A0 The two values, given as numbers of sectors, indicate a ran=
ge
-+ =A0 =A0 withing the array where 'check'/'repair' will operate. Must =
be
++     within the array where 'check'/'repair' will operate. Must be
> + =A0 =A0 a multiple of chunk_size. When it reaches "sync_max" it wil=
l
> + =A0 =A0 pause, rather than complete.
> + =A0 =A0 You can use 'select' or 'poll' on "sync_completed" to wait =
for
> + =A0 =A0 that number to reach sync_max. =A0Then you can either incre=
ase
> + =A0 =A0 "sync_max", or can write 'idle' to "sync_action".
> +
>
> =A0Each active md device may also have attributes specific to the
> =A0personality module that manages it.
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
