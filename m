From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Detect too-small device: error rather than
 underflow/crash
Date: Fri, 5 Jun 2020 11:21:32 -0400
Message-ID: <d4aa93ea-8810-db0b-15d2-2d68d8c7f3e1@trained-monkey.org>
References: <20200523122459.1151100-1-dfavro@meta-dynamic.com>
 <20200523122459.1151100-2-dfavro@meta-dynamic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200523122459.1151100-2-dfavro@meta-dynamic.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: dfavro@meta-dynamic.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/23/20 8:24 AM, dfavro@meta-dynamic.com wrote:
> From: David Favro <dfavro@meta-dynamic.com>
> 
> For 1.x metadata, when the user requested creation of an array on
> component devices that were too small even to hold the superblock,
> an undetected integer wraparound (underflow) resulted in an enormous
> computed size which resulted in various follow-on errors such as
> floating-point exception.
> 
> This patch detects this condition, prints a reasonable diagnostic
> message, and refuses to continue.
> 
> Signed-off-by: David Favro <dfavro@meta-dynamic.com>
> ---
>  super1.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)

Applied!

Thanks,
Jes
