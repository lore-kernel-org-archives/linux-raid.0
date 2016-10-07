From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH - mdadm] Fix some issues found by clang
Date: Fri, 07 Oct 2016 11:48:58 -0400
Message-ID: <wrfjk2dkdus5.fsf@redhat.com>
References: <8737k84xuf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8737k84xuf.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Fri, 07 Oct 2016 14:55:20 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> The clang compiler complained about each of these.
>
> The mdmon.h error will only affect 'far' RAID10 arrays using intel or DDF
> metadata, and there is no such thing.
>
> The mdopen.c will cause a problem if there are no free md device
> numbers in the first 512.  That is fairly unlikely.
>
> The restripe.c error would only affect the 'test_stripe' command, and
> probably doesn't change its behaviour.
>
> The super-intel.c fix is purely cosmetic.
>
> Signed-off-by: NeilBrown <neilb@suse.com>

Oh neat! There are some real gems in there. Now I don't feel so bad
about the brown paper bag bug I found in my wireless driver last night
:)

Applied!

Thanks,
Jes
