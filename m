From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v2] md: improve io stats accounting
Date: Thu, 2 Jul 2020 16:17:25 +0200
Message-ID: <63851623-9546-637f-446b-b84cdec61a38@intel.com>
References: <20200702105440.17097-1-artur.paszkiewicz@intel.com>
 <c2579e84-dc89-68fe-f6fc-81ad80d3f3ee@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c2579e84-dc89-68fe-f6fc-81ad80d3f3ee@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/2/20 3:55 PM, Guoqing Jiang wrote:
> It can just be "md_io->start_time = bio_start_io_acct(bio)", with that

Oh, nice. I haven't noticed that. I'll resend.

Thanks,
Artur
