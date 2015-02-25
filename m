From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 4/5] IncrementalScan(): Make sure 'st' is valid before
 dereferencing it
Date: Wed, 25 Feb 2015 10:00:18 -0500
Message-ID: <21741.58242.604155.228473@quad.stoffel.home>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
	<1424811640-26569-5-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424811640-26569-5-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Jes" == Jes Sorensen <Jes.Sorensen@redhat.com> writes:

Jes> From: Jes Sorensen <Jes.Sorensen@redhat.com>
Jes> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Jes> ---
Jes>  Incremental.c | 2 +-
Jes>  1 file changed, 1 insertion(+), 1 deletion(-)

Jes> diff --git a/Incremental.c b/Incremental.c
Jes> index 87d9114..33c0d7f 100644
Jes> --- a/Incremental.c
Jes> +++ b/Incremental.c
Jes> @@ -1354,7 +1354,7 @@ restart:
Jes>  			if (st && st->ss->load_container)
Jes>  				ret = st->ss->load_container(st, mdfd, NULL);
Jes>  			close(mdfd);
Jes> -			if (!ret && st->ss->container_content) {
Jes> +			if (!ret && st && st->ss->container_content) {
Jes>  				if (map_lock(&map))
Jes>  					pr_err("failed to get exclusive lock on mapfile\n");
Jes>  				ret = Incremental_container(st, me->path, c, only);
Jes> -- 
Jes> 2.1.0

Forgive my stupidity, but how does this really help anything?  You
already did the check above for a valid 'st', and now you're just
repeating it.  Maybe if needs to be more of:

  if (st) {
    if (st->ss->load_container)
       ret = st->ss->load_container(st,mdfd, NULL);
    close(mdfd);
    if (!ret && st->ss->container_content) {
      .....
    }
  }

but maybe I'm just missing something here. 

John

  
