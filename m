From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] imsm: fix reading scsi serial
Date: Thu, 2 Nov 2017 11:33:26 -0400
Message-ID: <d890f7d5-ff5c-8c59-47e1-764c46f8799b@gmail.com>
References: <20171102151057.3398-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171102151057.3398-1-artur.paszkiewicz@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On 11/02/2017 11:10 AM, Artur Paszkiewicz wrote:
> Improve error detection after SG_IO ioctl. Checking only the return
> value and response length is insufficient and leads to anomalies if a
> drive does not have a serial number.
> 
> Reported-by: NeilBrown <neilb@suse.com>
> Tested-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
> Mailing list discussion: https://marc.info/?l=linux-raid&m=150950864700415&w=2
> 
>  sg_io.c | 3 +++
>  1 file changed, 3 insertions(+)

Seems reasonable - applied!

Thanks,
Jes

