From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [mdadm PATCH] Introduce enum flag_mode for setting and clearing flags.
Date: Tue, 29 Nov 2016 17:12:39 -0500
Message-ID: <wrfj60n69bqg.fsf@redhat.com>
References: <147944614789.3302.1959091446949640579.stgit@noble>
        <20161122020238.qtuxwo5etcwmts4r@kernel.org>
        <87polka0vu.fsf@notabene.neil.brown.name>
        <wrfjfumbpv7f.fsf@redhat.com>
        <877f7m7xng.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f7m7xng.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Wed, 30 Nov 2016 09:02:11 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> We currently use '1' to indicate that a flag (writemostly or failfast)
> needs to be set, and '2' to indicate that it needs to be cleared.
>
> Using magic number like this is not a best-practice.
>
> So replaced them with values from a enum.
>
> No functional change.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>
> Ask, and you shall receive :-)

Darn, are you trying ot put me to work?

Applied!

Thanks,
Jes
