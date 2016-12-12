From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] imsm: set generation number when reading superblock
Date: Mon, 12 Dec 2016 14:25:15 -0500
Message-ID: <wrfj1sxdt0f8.fsf@redhat.com>
References: <1481195568-12973-1-git-send-email-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1481195568-12973-1-git-send-email-mariusz.dabrowski@intel.com>
        (Mariusz Dabrowski's message of "Thu, 8 Dec 2016 12:12:48 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mariusz Dabrowski <mariusz.dabrowski@intel.com> writes:
> IMSM doesn't set 'events' field with generation number, so sometimes mdadm
> tries to re-assembly container using metadata which isn't most recent (e. g.
> from spare disk).
>
> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> ---
>  super-intel.c | 1 +
>  1 file changed, 1 insertion(+)

Applied!

Thanks,
Jes
