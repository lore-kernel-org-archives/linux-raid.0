From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: mdadm: super0: do not override uuid with homehost
Date: Sat, 20 Oct 2012 20:09:27 +0400
Message-ID: <5082CCB7.3010402@msgid.tls.msk.ru>
References: <20121020154002.F24612C12@gandalf.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121020154002.F24612C12@gandalf.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20.10.2012 19:40, Michael Tokarev wrote:
> When --uuid is specified in the command line, even for v0.90
> superblock we override last portion of uuid with data from
> --homehost, which is wrong (and disagrees with the manpage).
> Only use homehost in super0 if no uuid is specified.
> 
> Signed-off-By: Michael Tokarev <mjt@tls.msk.ru>
> 
> diff --git a/super0.c b/super0.c
> index 1375799..ca4c082 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -657,7 +657,7 @@ static int init_super0(struct supertype *st, mdu_array_info_t *info,
>  		if (rfd >= 0)
>  			close(rfd);
>  	}
> -	if (homehost) {
> +	if (homehost && !uuid) {

Besides, do we need to check *homehost here too,
in order to be able to unset homehost given in
config file or whatnot, by setting it to an empty
string?

/mjt


>  		char buf[20];
>  		char *hash = sha1_buffer(homehost,
>  					 strlen(homehost),

