From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 3/5] add_orom(): Compare content of struct imsm_orom rather
 than pointers to it
Date: Wed, 25 Feb 2015 11:51:10 +0100
Message-ID: <54EDA91E.5050005@intel.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com> <1424811640-26569-4-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424811640-26569-4-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/24/2015 10:00 PM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This avoids adding the same orom entry to the oroms list multiple
> times, as the comparison of pointers is never going to succeed, in
> particular when '*orom' points to a local stack variable in the
> calling function.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  platform-intel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/platform-intel.c b/platform-intel.c
> index 37274da..a4ffa9f 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -255,8 +255,8 @@ static const struct imsm_orom *add_orom(const struct imsm_orom *orom)
>  	int i;
>  
>  	for (i = 0; i < SYS_DEV_MAX; i++) {
> -		if (&oroms[i].orom == orom)
> -			return orom;
> +		if (!memcmp(&oroms[i].orom, orom, sizeof(struct imsm_orom)))
> +			return &oroms[i].orom;
>  		if (oroms[i].orom.signature[0] == 0) {
>  			oroms[i].orom = *orom;
>  			return &oroms[i].orom;
> 

Hi Jes,

You are right that this can add the same entry multiple times, but this
is how it is supposed to work. The oroms list should contain all the
platform's oroms and they can be the same, this is why memcmp() should
not be used here. We don't want to compare the contents of the
structure, just its address. Sorry if it's not clear.

Artur

