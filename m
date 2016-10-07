From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Fix bus error when accessing MBR partition records
Date: Fri, 07 Oct 2016 11:14:44 -0400
Message-ID: <wrfjshs8dwd7.fsf@redhat.com>
References: <20160929122838.66975-1-jrtc27@jrtc27.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160929122838.66975-1-jrtc27@jrtc27.com> (James Clarke's
        message of "Thu, 29 Sep 2016 13:28:38 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: James Clarke <jrtc27@jrtc27.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

James Clarke <jrtc27@jrtc27.com> writes:
> Since the MBR layout only has partition records as 2-byte aligned, the 32-bit
> fields in them are not aligned. Thus, they cannot be accessed on some
> architectures (such as SPARC) by using a "struct MBR_part_record *" pointer,
> as the compiler can assume that the pointer is properly aligned. Instead, the
> records must be accessed by going through the MBR struct itself every time.
>
> Signed-off-by: James Clarke <jrtc27@jrtc27.com>
> ---
>  super-mbr.c |  6 ++++++
>  util.c      | 14 +++++++-------
>  2 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/super-mbr.c b/super-mbr.c
> index 62b3f03..303dde4 100644
> --- a/super-mbr.c
> +++ b/super-mbr.c
> @@ -57,6 +57,9 @@ static void examine_mbr(struct supertype *st, char *homehost)
>  
>  	printf("   MBR Magic : %04x\n", sb->magic);
>  	for (i = 0; i < MBR_PARTITIONS; i++)
> +		/* Have to make every access through sb rather than using a pointer to
> +		 * the partition table (or an entry), since the entries are not
> +		 * properly aligned. */
>  		if (sb->parts[i].blocks_num)
>  			printf("Partition[%d] : %12lu sectors at %12lu (type %02x)\n",
>  			       i,

Reading through this thread and Neil's comments, I think it's reasonable
to do what you are doing with pointer access. However I also believe
that packed should be applied as Neil suggests.

Second, as code lines per definition are 80 characters wide, please make
sure your patch complies with this. I know some of the older code
violates this, but we shouldn't be adding more code which does so.

If you send me an updated patch I shall be happy to apply it.

Jes
