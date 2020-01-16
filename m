From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Respect $(CROSS_COMPILE) when $(CC) is the default
Date: Thu, 16 Jan 2020 13:47:18 -0500
Message-ID: <f6916112-b52e-8fb7-e0db-01192537e72b@trained-monkey.org>
References: <20191209205413.6839-1-dann.frazier@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20191209205413.6839-1-dann.frazier@canonical.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: dann frazier <dann.frazier@canonical.com>
Cc: Helmut Grohne <helmut@subdivi.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/9/19 3:54 PM, dann frazier wrote:
> Commit 1180ed5 told make to only respect $(CROSS_COMPILE) when $(CC)
> was unset. But that will never be the case, as make provides
> a default value for $(CC). Change this logic to respect $(CROSS_COMPILE)
> when $(CC) is the default. Patch originally by Helmet Grohne.
> 
> Fixes: 1180ed5 ("Makefile: make the CC definition conditional")
> Signed-off-by: dann frazier <dann.frazier@canonical.com>
> ---
>  Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes
