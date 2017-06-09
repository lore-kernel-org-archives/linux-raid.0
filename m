From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Grow: don't allow array geometry change with ppl enabled
Date: Fri, 9 Jun 2017 10:56:52 -0400
Message-ID: <d661109d-5b97-7b08-62f4-0f452a9d1e53@gmail.com>
References: <1496930751-9220-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1496930751-9220-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/08/2017 10:05 AM, Tomasz Majchrzak wrote:
> Don't allow array geometry change (size expand, disk adding) when PPL
> consistency policy is enabled. Current PPL implementation doesn't work when
> reshape is taking place.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   Grow.c | 7 +++++++
>   1 file changed, 7 insertions(+)

Applied!

Thanks,
Jes

