From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] imsm: FIX: klocwork: passed dev pointer to
 is_gen_migration() can be NULL
Date: Tue, 14 Jun 2011 12:50:53 +1000
Message-ID: <20110614125053.36e73b4e@notabene.brown>
References: <20110610154856.24539.28960.stgit@gklab-128-013.igk.intel.com>
	<20110610155639.24539.67025.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110610155639.24539.67025.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Fri, 10 Jun 2011 17:56:39 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Pointer dev2 passed in write_super_imsm():4451 can be equal to NULL.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 8dd0805..3b4010d 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5321,6 +5321,9 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
>  
>  static int is_gen_migration(struct imsm_dev *dev)
>  {
> +	if (dev == NULL)
> +		return 0;
> +
>  	if (!dev->vol.migr_state)
>  		return 0;
>  


Thanks.  I have applied this and most of the others you sent. 

NeilBrown

