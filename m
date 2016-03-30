From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Introduce stat2kname() and fd2kname()
Date: Wed, 30 Mar 2016 11:26:31 -0400
Message-ID: <wrfjy490rnq0.fsf@redhat.com>
References: <1459257629-22027-1-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1459257629-22027-1-git-send-email-artur.paszkiewicz@intel.com>
	(Artur Paszkiewicz's message of "Tue, 29 Mar 2016 15:20:29 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> These are similar to stat2devnm() and fd2devnm() but not limited to md
> devices. If the device is a partition they will return its kernel name,
> not the whole device's name. For more information see commit:
> 8d83493 ("Introduce devid2kname - slightly different to devid2devnm.")
>
> Also remove unsued declaration for fmt_devname().
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  lib.c         | 15 +++++++++++++++
>  mdadm.h       |  3 ++-
>  super-intel.c |  6 +++++-
>  3 files changed, 22 insertions(+), 2 deletions(-)

Applied, thanks!

Jes
