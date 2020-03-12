From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] imsm: Correct minimal device size.
Date: Thu, 12 Mar 2020 10:30:56 -0400
Message-ID: <7a4fdbc6-a3a3-2bda-e3dd-46fb214bc82b@trained-monkey.org>
References: <20200311144013.24424-1-blazej.kucman@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200311144013.24424-1-blazej.kucman@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Blazej Kucman <blazej.kucman@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/11/20 10:40 AM, Blazej Kucman wrote:
> Check if given size of member drive is not less than 1 MibiByte.
> 
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>  super-intel.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes
