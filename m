From: Neil Brown <neilb@suse.de>
Subject: Re: [[Patch mdadm] 5/5] Fix segfault when the AUTO keyword is used
 in the config file
Date: Tue, 19 Jan 2010 11:03:45 +1300
Message-ID: <20100119110345.27acedfc@notabene>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	<1263242294-5353-6-git-send-email-dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1263242294-5353-6-git-send-email-dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, 11 Jan 2010 15:38:14 -0500
Doug Ledford <dledford@redhat.com> wrote:

> Signed-off-by: Doug Ledford <dledford@redhat.com>

Applied, thanks.

NeilBrown


> ---
>  config.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/config.c b/config.c
> index c962afd..2943221 100644
> --- a/config.c
> +++ b/config.c
> @@ -677,12 +677,21 @@ void homehostline(char *line)
>  static char *auto_options = NULL;
>  void autoline(char *line)
>  {
> +	char *w;
> +
>  	if (auto_options) {
>  		fprintf(stderr, Name ": AUTO line may only be give once."
>  			"  Subsequent lines ignored\n");
>  		return;
>  	}
> -	auto_options = line;		
> +
> +	auto_options = dl_strdup(line);		
> +	dl_init(auto_options);
> +
> +	for (w=dl_next(line); w != line ; w=dl_next(w)) {
> +		char *w2 = dl_strdup(w);
> +		dl_add(auto_options, w2);
> +	}
>  }
>  
>  int loaded = 0;

