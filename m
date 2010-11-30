From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] FIX: chunk_size cannot be read by mdstat
Date: Tue, 30 Nov 2010 11:22:11 +1100
Message-ID: <20101130112211.700f5940@notabene.brown>
References: <20101129095650.12551.98023.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101129095650.12551.98023.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Mon, 29 Nov 2010 10:56:50 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Chunk size is not read by mdstat due to too week checking of 'check' string in mdstat.
> It is the same result for 'check' and 'chunk_size' check.

Actually chunk size is not read because there is no code to try to read it.
The chunk size needs to be reported by the personality, and they are
inconsistent in the way they report it so it is much easier to just ignore it.
GET_ARRAY_INFO gets the chunk size easily, so we stick with that when chunk
size is needed.

Thanks,
NeilBrown



> 
> Add  string length additional condition for checking.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  mdstat.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mdstat.c b/mdstat.c
> index bb030bf..5f69e31 100644
> --- a/mdstat.c
> +++ b/mdstat.c
> @@ -248,7 +248,8 @@ struct mdstat_ent *mdstat_read(int hold, int start)
>  				else
>  					ent->resync = 0;
>  			} else if (ent->percent == -1 &&
> -				   (w[0] == 'r' || w[0] == 'c')) {
> +				   (w[0] == 'r' ||
> +				    ((w[0] == 'c') && strlen(w) < 9))) {
>  				if (strncmp(w, "resync", 4)==0)
>  					ent->resync = 1;
>  				if (strncmp(w, "reshape", 7)==0)

