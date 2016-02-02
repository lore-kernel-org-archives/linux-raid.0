From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH/mdadm] super1: Fix bblog_size accesses on big-ending machines.
Date: Tue, 02 Feb 2016 07:20:15 -0500
Message-ID: <wrfjk2mn1eyo.fsf@redhat.com>
References: <87d1sl182i.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1sl182i.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Fri, 29 Jan 2016 12:35:33 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> bblog_size is 16bit so using le32_to_cpu on it is not wise
> and leads to errors on big-endian machines.
> Change all such calls to use le16.
>
> Bug was introduced in mdadm-3.3
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>
> Hi Jes,
>  when you are ready to start queuing patches for mdadm, this will make
>  sure you have something to work with:-)
>
> Thanks,
> NeilBrown

Applied!

Thanks,
Jes

>
>  super1.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/super1.c b/super1.c
> index 8bcaa2fe02c8..9b877e504c4b 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -730,12 +730,12 @@ static int copy_metadata1(struct supertype *st, int from, int to)
>  	}
>  
>  	if (super.bblog_size != 0 &&
> -	    __le32_to_cpu(super.bblog_size) <= 100 &&
> +	    __le16_to_cpu(super.bblog_size) <= 100 &&
>  	    super.bblog_offset != 0 &&
>  	    (super.feature_map & __le32_to_cpu(MD_FEATURE_BAD_BLOCKS))) {
>  		/* There is a bad block log */
>  		unsigned long long bb_offset = sb_offset;
> -		int bytes = __le32_to_cpu(super.bblog_size) * 512;
> +		int bytes = __le16_to_cpu(super.bblog_size) * 512;
>  		int written = 0;
>  		struct align_fd afrom, ato;
>  
> @@ -832,7 +832,7 @@ static int examine_badblocks_super1(struct supertype *st, int fd, char *devname)
>  	__u64 *bbl, *bbp;
>  	int i;
>  
> -	if  (!sb->bblog_size || __le32_to_cpu(sb->bblog_size) > 100
> +	if  (!sb->bblog_size || __le16_to_cpu(sb->bblog_size) > 100
>  	     || !sb->bblog_offset){
>  		printf("No bad-blocks list configured on %s\n", devname);
>  		return 0;
> @@ -843,7 +843,7 @@ static int examine_badblocks_super1(struct supertype *st, int fd, char *devname)
>  		return 0;
>  	}
>  
> -	size = __le32_to_cpu(sb->bblog_size)* 512;
> +	size = __le16_to_cpu(sb->bblog_size)* 512;
>  	if (posix_memalign((void**)&bbl, 4096, size) != 0) {
>  		pr_err("could not allocate badblocks list\n");
>  		return 0;
> @@ -986,7 +986,7 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
>  		if (sb->bblog_offset && sb->bblog_size) {
>  			unsigned long long bbend = super_offset;
>  			bbend += (int32_t)__le32_to_cpu(sb->bblog_offset);
> -			bbend += __le32_to_cpu(sb->bblog_size);
> +			bbend += __le16_to_cpu(sb->bblog_size);
>  			if (bbend > earliest)
>  				earliest = bbend;
>  		}
