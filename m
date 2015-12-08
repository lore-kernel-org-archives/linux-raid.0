From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH 1/2] [mdadm] fix bug in assemble
Date: Tue, 8 Dec 2015 01:11:25 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AA0104BCB4C7@PRN-MBX02-4.TheFacebook.com>
References: <1449536919-3773378-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449536919-3773378-1-git-send-email-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.com" <neilb@suse.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, Shaohua Li <shli@fb.com>, "hch@infradead.org" <hch@infradead.org>, Kernel Team <Kernel-team@fb.com>
List-Id: linux-raid.ids

This is the only patch, not [1/2]. 

Thanks,
Song


> -----Original Message-----
> From: Song Liu [mailto:songliubraving@fb.com]
> Sent: Monday, December 7, 2015 5:09 PM
> To: linux-raid@vger.kernel.org
> Cc: neilb@suse.com; dan.j.williams@intel.com; Shaohua Li <shli@fb.com>;
> hch@infradead.org; Kernel Team <Kernel-team@fb.com>; Song Liu
> <songliubraving@fb.com>
> Subject: [PATCH 1/2] [mdadm] fix bug in assemble
> 
> In Assemble, getinfo_super() over writes journal_clean, to same correct journal
> clean, keep it in "journal_clean_tmp" before getinfo_super().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  Assemble.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index 6b9a6da..0ab5943 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1302,6 +1302,7 @@ int Assemble(struct supertype *st, char *mddev,
>  	int bestcnt = 0;
>  	int devcnt;
>  	unsigned int okcnt, sparecnt, rebuilding_cnt, replcnt, journalcnt;
> +	int journal_clean_tmp = 0;
>  	int i;
>  	int was_forced = 0;
>  	int most_recent = 0;
> @@ -1592,7 +1593,7 @@ try_again:
>  			) {
>  			devices[j].uptodate = 1;
>  			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL))
> -				content->journal_clean = 1;
> +				journal_clean_tmp = 1;  /* store in
> journal_clean_tmp */
>  			if (i < content->array.raid_disks * 2) {
>  				if (devices[j].i.recovery_start == MaxSector ||
>  				    (content->reshape_active &&
> @@ -1664,6 +1665,8 @@ try_again:
>  #ifndef MDASSEMBLE
>  	sysfs_init(content, mdfd, NULL);
>  #endif
> +	/* after reload context, store journal_clean in context */
> +	content->journal_clean = journal_clean_tmp;
>  	for (i=0; i<bestcnt; i++) {
>  		int j = best[i];
>  		unsigned int desired_state;
> --
> 2.4.6

