From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Add spare throws exception (v2)
Date: Sun, 20 Mar 2011 15:48:53 +1100
Message-ID: <20110320154853.73944827@notabene.brown>
References: <20110318090804.8068.28272.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110318090804.8068.28272.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Fri, 18 Mar 2011 10:08:04 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> sync_metadata() requires st->sb to be loaded, otherwise exception is generated.
> This fails expansion, because spares cannot be added.
> 
> metadata update uses tst instead st pointer, it is better than
> loading anchor for st as I proposed previously.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Manage.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Manage.c b/Manage.c
> index 5808557..217c6b6 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -914,10 +914,10 @@ int Manage_subdevs(char *devname, int fd,
>  					close(container_fd);
>  					return 1;
>  				}
> -				if (st->update_tail)
> -					flush_metadata_updates(st);
> +				if (tst->update_tail)
> +					flush_metadata_updates(tst);
>  				else
> -					tst->ss->sync_metadata(st);
> +					tst->ss->sync_metadata(tst);
>  
>  				sra = sysfs_read(container_fd, -1, 0);
>  				if (!sra) {

Yes, this is better thanks.

'st' is only used to read the superblock of the new device to see if it is
already a member of the array and so a 're-add' is appropriate.
'tst' should be used whenever working on 'the whole array'.

I really should give these variables better names.

Thanks,
NeilBrown
