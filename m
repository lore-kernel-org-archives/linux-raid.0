From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [mdadm PATCH] Make get_component_size() work with named array.
Date: Thu, 22 Dec 2016 12:19:27 -0500
Message-ID: <wrfjeg0zkhk0.fsf@redhat.com>
References: <87wpespv4s.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wpespv4s.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Thu, 22 Dec 2016 13:14:59 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Robert LeBlanc <robert@leblancnet.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> get_component_size() still assumes that all array are
>  /sys/block/md%d or /sys/block/md_d%d
> and so doesn't work with e.g. /sys/block/md_foo.
>
> This cause "mdadm --detail" to report
>    Used Dev Size : unknown
> and causes problems when added spares and in other circumstances.
>
> So change it to use stat2devnm() which does the right thing with all
> types of array names.
>
> Reported-and-tested-by: Robert LeBlanc <robert@leblancnet.us>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  sysfs.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Applied!

Thanks,
Jes
