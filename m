From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 19/53] imsm: Add support for general migration
Date: Mon, 29 Nov 2010 12:17:47 +1100
Message-ID: <20101129121747.7cca2a64@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080615.5221.22468.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126080615.5221.22468.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:06:15 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Internal IMSM procedures need to support the General Migration.
> It is used during operations like:
> - Online Capacity Expansion,
> - migration initialization,
> - finishing migration,
> - apply changes to raid disks etc.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  mdmon.h       |    2 +-
>  super-intel.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 56 insertions(+), 8 deletions(-)
> 
> diff --git a/mdmon.h b/mdmon.h
> index 5c51566..8190358 100644
> --- a/mdmon.h
> +++ b/mdmon.h
> @@ -76,7 +76,7 @@ void do_monitor(struct supertype *container);
>  void do_manager(struct supertype *container);
>  extern int sigterm;
>  
> -int read_dev_state(int fd);
> +extern int read_dev_state(int fd);
>  int is_container_member(struct mdstat_ent *mdstat, char *container);

Here is another case of irrelevant extra changes.  This change really isn't
needed.  'extern' before a function declaration is completely redundant.

It is true that in the various .h files, we sometimes do include 'extern' and
sometimes don't.  It might be good to be consistent, so a single patch which
makes them all consistent, either removing 'extern' from function
declarations or adding it where missing, would be OK.  But adding here when
you aren't changing anything else about the declaration is noise, and I
really don't need more noise.

I haven't applied the rest of this patch as I suspect it should be applied
after the 'imsm_reshape_super' patch is applied.

NeilBrown

