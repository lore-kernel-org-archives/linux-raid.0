From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH, v2] Add support for Tebibytes
Date: Tue, 21 Jan 2020 13:39:22 -0500
Message-ID: <089ad982-70f7-5224-9d1f-592abbd5d292@trained-monkey.org>
References: <20200121093852.21240-1-kinga.tanska@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200121093852.21240-1-kinga.tanska@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/21/20 4:38 AM, Kinga Tanska wrote:
> Adding support for Tebibytes enables display size of
> volumes in Tebibytes and Terabytes when they are
> bigger than 2048 GiB (or GB).
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  mdadm.8.in | 20 ++++++++++----------
>  util.c     | 47 +++++++++++++++++++++++++++++++++--------------
>  2 files changed, 43 insertions(+), 24 deletions(-)

Applied!

Thanks,
Jes
