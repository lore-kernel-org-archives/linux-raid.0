From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Prevent using null list pointer
Date: Wed, 7 Sep 2011 12:46:12 +1000
Message-ID: <20110907124612.23f90c4b@notabene.brown>
References: <20110901132836.3509.94391.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110901132836.3509.94391.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 01 Sep 2011 15:28:36 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> When not all attributes are supported (attributes incompatibility)
> function container_content_imsm returns NULL pointer.
> In this case mdadm should immediately exit with error to prevent
> using null "list" pointer.
> 
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Incremental.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Incremental.c b/Incremental.c
> index 951c2a0..deace7d 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1460,6 +1460,11 @@ static int Incremental_container(struct supertype *st, char *devname,
>  		trustworthy = FOREIGN;
>  
>  	list = st->ss->container_content(st, NULL);
> +	if (!list) {
> +		fprintf(stderr, Name ": Cannot get container content. "
> +				"Array cannot be assembled.\n");
> +		return 2;
> +	}
>  	if (map_lock(&map))
>  		fprintf(stderr, Name ": failed to get exclusive lock on "
>  			"mapfile\n");
> 

Thanks for the patch.
I'll like to handle NULL a bit differently though - see below.

Thanks,
NeilBrown

commit 75c2df6509391e28257d696815bddb854a8c4a94
Author: NeilBrown <neilb@suse.de>
Date:   Wed Sep 7 12:45:24 2011 +1000

    FIX: Prevent using null list pointer
    
    When not all attributes are supported (attributes incompatibility)
    function container_content_imsm returns NULL pointer.
    We need to cope with a NULL list better.
    
    Reported-by: Lukasz Dorau <lukasz.dorau@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Incremental.c b/Incremental.c
index 951c2a0..09cdd9b 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1464,7 +1464,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 		fprintf(stderr, Name ": failed to get exclusive lock on "
 			"mapfile\n");
 	/* do not assemble arrays that might have bad blocks */
-	if (list->array.state & (1<<MD_SB_BBM_ERRORS)) {
+	if (list && list->array.state & (1<<MD_SB_BBM_ERRORS)) {
 		fprintf(stderr, Name ": BBM log found in metadata. "
 					"Cannot activate array(s).\n");
 		/* free container data and exit */
diff --git a/policy.c b/policy.c
index ebb1481..2bbbac8 100644
--- a/policy.c
+++ b/policy.c
@@ -678,6 +678,8 @@ struct domainlist *domain_from_array(struct mdinfo *mdi, const char *metadata)
 {
 	struct domainlist *domlist = NULL;
 
+	if (!mdi)
+		return NULL;
 	for (mdi = mdi->devs ; mdi ; mdi = mdi->next)
 		domainlist_add_dev(&domlist, makedev(mdi->disk.major,
 						     mdi->disk.minor),
