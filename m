From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] imsm: show correct size for arrays with 4k disks
Date: Mon, 09 Jan 2017 09:26:24 -0500
Message-ID: <wrfjk2a4e2cv.fsf@redhat.com>
References: <1483971364-7343-1-git-send-email-maksymilian.kunt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1483971364-7343-1-git-send-email-maksymilian.kunt@intel.com>
        (Maksymilian Kunt's message of "Mon, 9 Jan 2017 15:16:04 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Maksymilian Kunt <maksymilian.kunt@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maksymilian Kunt <maksymilian.kunt@intel.com> writes:
> Number of blocks used to calculate array size is based on 512 block size
> so the size displayed is incorrect for arrays with 4k disks.
>
> Signed-off-by: Maksymilian Kunt <maksymilian.kunt@intel.com>
> ---
>  super-intel.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)

Applied!

Thanks,
Jes
