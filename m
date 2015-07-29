From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] Safeguard against writing to an active device of
 another node
Date: Thu, 30 Jul 2015 08:02:47 +1000
Message-ID: <20150730080247.20f03d23@noble>
References: <1436172732-21021-1-git-send-email-gqjiang@suse.com>
	<1436172732-21021-3-git-send-email-gqjiang@suse.com>
	<20150729172853.33d44808@noble>
	<55B8ADE1.1060708@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55B8ADE1.1060708@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqJiang@suse.com>
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jul 2015 18:41:37 +0800 Guoqing Jiang <gqJiang@suse.com>
wrote:

> Hi Neil,
> 
> NeilBrown wrote:
> > On Mon,  6 Jul 2015 16:52:12 +0800 Guoqing Jiang <gqjiang@suse.com>
> > wrote:
> >
> >   
> >> Modifying an exiting device's superblock or creating a new superblock
> >> on an existing device needs to be checked because the device could be
> >> in use by another node in another array. So, we check this by taking
> >> all superblock locks in userspace so that we don't  step onto an active
> >> device used by another node and safeguard against accidental edits.
> >> After the edit is complete, we release all locks and the lockspace so
> >> that it can be used by the kernel space.
> >>
> >> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >>     
> >
> > Hi,
> >  thanks for these.
> >  I've applied 1 and 2.
> >
> >  Could you re-do this on to follow the kernel style of #ifdefs,
> >  so that the #ifdefs only appear in header files.
> >  i.e. when NO_DLM is defined, is_clustered() always evaluates to zero
> >  and clustered_get_dlmlock() always succeeds etc.
> >   
> Thanks, I guess you mean the following incremental modification. Please
> let me know if I misunderstood.
> 
> diff --git a/mdadm.h b/mdadm.h
> index 59f851e..4d9e8c8 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1429,9 +1429,26 @@ extern char *fd2devnm(int fd);
> 
> extern int in_initrd(void);
> extern int get_cluster_name(char **name);
> +#ifndef NO_DLM
> extern int is_clustered(struct supertype *st);
> extern int cluster_get_dlmlock(struct supertype *st, int *lockid);
> extern int cluster_release_dlmlock(struct supertype *st, int lockid);
> +#else
> +static inline int is_clustered(struct supertype *st)
> +{
> + return 0;
> +}
> +
> +static inline int cluster_get_dlmlock(struct supertype *st, int *lockid)
> +{
> + return 0;
> +}
> +
> +static inline int cluster_release_dlmlock(struct supertype *st, int lockid)
> +{
> + return 0;
> +}
> +#endif
> 
> #define _ROUND_UP(val, base) (((val) + (base) - 1) & ~(base - 1))
> #define ROUND_UP(val, base) _ROUND_UP(val, (typeof(val))(base))
> diff --git a/super1.c b/super1.c
> index c49a3b3..bd88c36 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1072,10 +1072,9 @@ static int update_super1(struct supertype *st,
> struct mdinfo *info,
> * ignored.
> */
> int rv = 0;
> + int lockid;
> struct mdp_superblock_1 *sb = st->sb;
> 
> -#ifndef NO_DLM
> - int lockid;
> if (is_clustered(st)) {
> rv = cluster_get_dlmlock(st, &lockid);
> if (rv) {
> @@ -1084,7 +1083,6 @@ static int update_super1(struct supertype *st,
> struct mdinfo *info,
> return rv;
> }
> }
> -#endif
> 
> if (strcmp(update, "homehost") == 0 &&
> homehost) {
> @@ -1342,10 +1340,9 @@ static int update_super1(struct supertype *st,
> struct mdinfo *info,
> rv = -1;
> 
> sb->sb_csum = calc_sb_1_csum(sb);
> -#ifndef NO_DLM
> if (is_clustered(st))
> cluster_release_dlmlock(st, lockid);
> -#endif
> +
> return rv;
> }
> 
> @@ -1449,9 +1446,8 @@ static int add_to_super1(struct supertype *st,
> mdu_disk_info_t *dk,
> struct mdp_superblock_1 *sb = st->sb;
> __u16 *rp = sb->dev_roles + dk->number;
> struct devinfo *di, **dip;
> -
> -#ifndef NO_DLM
> int rv, lockid;
> +
> if (is_clustered(st)) {
> rv = cluster_get_dlmlock(st, &lockid);
> if (rv) {
> @@ -1460,7 +1456,7 @@ static int add_to_super1(struct supertype *st,
> mdu_disk_info_t *dk,
> return rv;
> }
> }
> -#endif
> +
> if ((dk->state & 6) == 6) /* active, sync */
> *rp = __cpu_to_le16(dk->raid_disk);
> else if ((dk->state & ~2) == 0) /* active or idle -> spare */
> @@ -1487,10 +1483,9 @@ static int add_to_super1(struct supertype *st,
> mdu_disk_info_t *dk,
> di->next = NULL;
> *dip = di;
> 
> -#ifndef NO_DLM
> if (is_clustered(st))
> cluster_release_dlmlock(st, lockid);
> -#endif
> +
> return 0;
> }
> #endif
> @@ -1504,9 +1499,8 @@ static int store_super1(struct supertype *st, int fd)
> struct align_fd afd;
> int sbsize;
> unsigned long long dsize;
> -
> -#ifndef NO_DLM
> int rv, lockid;
> +
> if (is_clustered(st)) {
> rv = cluster_get_dlmlock(st, &lockid);
> if (rv) {
> @@ -1515,7 +1509,6 @@ static int store_super1(struct supertype *st, int fd)
> return rv;
> }
> }
> -#endif
> 
> if (!get_dev_size(fd, NULL, &dsize))
> return 1;
> @@ -1576,10 +1569,9 @@ static int store_super1(struct supertype *st, int fd)
> }
> }
> fsync(fd);
> -#ifndef NO_DLM
> if (is_clustered(st))
> cluster_release_dlmlock(st, lockid);
> -#endif
> +
> return 0;
> }
> 
> @@ -2329,7 +2321,6 @@ static int write_bitmap1(struct supertype *st, int
> fd, enum bitmap_update update
> 
> static void free_super1(struct supertype *st)
> {
> -#ifndef NO_DLM
> int rv, lockid;
> if (is_clustered(st)) {
> rv = cluster_get_dlmlock(st, &lockid);
> @@ -2339,7 +2330,7 @@ static void free_super1(struct supertype *st)
> return;
> }
> }
> -#endif
> +
> if (st->sb)
> free(st->sb);
> while (st->info) {
> @@ -2350,10 +2341,8 @@ static void free_super1(struct supertype *st)
> free(di);
> }
> st->sb = NULL;
> -#ifndef NO_DLM
> if (is_clustered(st))
> cluster_release_dlmlock(st, lockid);
> -#endif
> }
> 
> #ifndef MDASSEMBLE
> 
> Thanks,
> Guoqing

Probably something like that - yes.  Unfortunately your mailer messed
that up more that usual make it rather difficult to apply.

I was wondering if we could make it a run-time dependency though .. a
bit like get_cluster_name.  We can still do that later I guess.  I'm
not really sure what is best at the moment.

Thanks,
NeilBrown
