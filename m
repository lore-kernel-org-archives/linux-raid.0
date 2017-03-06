From: jes.sorensen@gmail.com
Subject: Re: [PATCH - mdadm] examine: tidy up some code.
Date: Mon, 06 Mar 2017 16:34:04 -0500
Message-ID: <wrfjvarmks37.fsf@gmail.com>
References: <878tonnsfn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878tonnsfn.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Fri, 03 Mar 2017 10:57:00 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Michael Shigorin <mike@altlinux.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> Michael Shigorin reports that the 'lcc' compiler isn't able
> to deduce that 'st' must be initialized in
>
> 		if (c->SparcAdjust)
> 			st->ss->update_super(st, NULL, "sparc2.2",
>
> just because the only times it isn't initialised, 'err' is set non-zero.
>
> This results in a 'possibly uninitialised' warning.
> While there is no bug in the code, this does suggest that maybe
> the code could be made more obviously correct.
>
> So this patch:
>  1/ moves the "err" variable inside the for loop, so an error in
>     one device doesn't stop the other devices from being processed
>  2/ calls 'continue' early if the device cannot be opened, so that
>     a level of indent can be removed, and so that it is clear that
>     'st' is always initialised before being used
>  3/ frees 'st' if an error occured in load_super or load_container.
>
> Reported-by: Michael Shigorin <mike@altlinux.org>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Examine.c | 75 +++++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 39 insertions(+), 36 deletions(-)

Applied!

Thanks,
Jes
