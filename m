From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: mdadm 3.4-1, error msg. on boot - no /usr/lib/systemd/scripts/mdadm_env.sh
Date: Tue, 07 Jun 2016 15:31:00 -0400
Message-ID: <wrfjziqwyex7.fsf@redhat.com>
References: <5754CBF2.8000309@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5754CBF2.8000309@suddenlinkmail.com> (David C. Rankin's message
	of "Sun, 5 Jun 2016 20:03:46 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"David C. Rankin" <drankinatty@suddenlinkmail.com> writes:
> Neil, All,
>
>   I'm chasing down the reason there is no
> /usr/lib/systemd/scripts/mdadm_env.sh provided with mdadm. This is
> more a curiosity really as mdmonitor continues to run, but it always
> throws an error at boot:
>
> Jun 05 17:12:47 valhalla systemd[454]: mdmonitor.service: Failed at step EXEC
> spawning /usr/lib/systemd/scripts/mdadm_env.sh: No such file or directory
>
>   I have several Arch servers, all on mdadm 3.4-1. I ran into an issue
> a year or so ago with a boot error with mdmonitor due to my failure to
> provide MAILADDR in /etc/mdadm.com, but that has long since been
> corrected:

If you're running Arch Linux, you probably want to direct this question
to the Arch Linux maintainers.

Jes
