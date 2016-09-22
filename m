From: Anthony DeRobertis <anthony@derobert.net>
Subject: Re: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Thu, 22 Sep 2016 12:53:34 -0400
Message-ID: <20160922165334.fuxch2eyxnlru5iu@derobert.net>
References: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
 <57E0CB6C.2040000@suse.com>
 <63417807-ae42-ed60-8c8b-3b699994c34c@derobert.net>
 <57E10311.7040601@suse.com>
 <1931152f-f5bc-bc1f-76a8-91921ffc1bed@derobert.net>
 <57E22C76.6040600@suse.com>
 <57E34496.8020108@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57E34496.8020108@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, 837964@bugs.debian.org
List-Id: linux-raid.ids

On Wed, Sep 21, 2016 at 10:40:22PM -0400, Guoqing Jiang wrote:
> 
> Does the below change work? Thanks.

Yes, this patch (after un-email-mangling it) fixes it.

> 
> diff --git a/super1.c b/super1.c
> index 9f62d23..6a0b075 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2433,7 +2433,10 @@ static int write_bitmap1(struct supertype *st, int
> fd, enum bitmap_update update
>                         memset(buf, 0xff, 4096);
>                 memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
> 
> -               towrite = calc_bitmap_size(bms, 4096);
> +               if (__le32_to_cpu(bms->nodes) == 0)
> +                       towrite = calc_bitmap_size(bms, 512);
> +               else
> +                       towrite = calc_bitmap_size(bms, 4096);
>                 while (towrite > 0) {
> 
> Regards,
> Guoqing
