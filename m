From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] IMSM: Update num_data_stripes during migration
Date: Mon, 28 Nov 2016 17:42:10 -0500
Message-ID: <wrfjh96rmdkt.fsf@redhat.com>
References: <20161124084824.28155-1-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161124084824.28155-1-pawel.baldysiak@intel.com> (Pawel
        Baldysiak's message of "Thu, 24 Nov 2016 09:48:24 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, Maksymilian Kunt <maksymilian.kunt@intel.com>
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> This patch adds updataing num_data_stripes during reshape.
> Previously this field once set during creation was never updated.
> Also, num_data_strips value multipied by chunk_size is used
> for set proper component size for RAID5.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Signed-off-by: Maksymilian Kunt <maksymilian.kunt@intel.com>
> ---
>  super-intel.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 46 insertions(+), 7 deletions(-)

Applied!

Thanks,
Jes
