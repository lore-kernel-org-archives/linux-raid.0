From: jes.sorensen@gmail.com
Subject: Re: [mdadm PATCH] udev-md-raid-assembly.rules: Skip non-ready devices
Date: Tue, 28 Mar 2017 14:22:43 -0400
Message-ID: <wrfjr31hfeh8.fsf@gmail.com>
References: <87fuhz8thr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fuhz8thr.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 27 Mar 2017 11:15:44 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> From: Hannes Reinecke <hare@suse.de>
>
> If a device isn't fully initialized (e.g if it should be
> handled by multipathing) it should not be considered for
> md/RAID auto-assembly.  Doing so can cause incorrect results
> such as causing multipath to fail during startup.
>
> There is a convention that the udev environment variable
> SYSTEMD_READY be set to zero for such devices.  So change
> the mdadm rules to ignore devices with SYSTEMD_READY==0.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  udev-md-raid-assembly.rules | 3 +++
>  1 file changed, 3 insertions(+)

Applied!

Thanks,
Jes
