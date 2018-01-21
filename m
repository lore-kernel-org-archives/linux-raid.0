From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] mdadm: allow clustered raid10 to be created with default
 layout
Date: Sun, 21 Jan 2018 15:56:40 -0500
Message-ID: <a4ac1fd6-4a71-f373-46c3-bbba94882a38@gmail.com>
References: <20180103070122.5195-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180103070122.5195-1-gqjiang@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/03/2018 02:01 AM, Guoqing Jiang wrote:
> Since the default layout of raid10 is n2, so we
> should allow the behavior.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  mdadm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes

