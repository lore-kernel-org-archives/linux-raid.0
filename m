From: Eli Stair <estair@ilm.com>
Subject: Re: BUGS: internal bitmap during array create
Date: Thu, 19 Oct 2006 16:34:35 -0700
Message-ID: <45380B8B.4040701@ilm.com>
References: <452D500D.6000203@ilm.com><17710.65130.194296.801803@cse.unsw.edu.au><4536B809.7020006@ilm.com> <17719.8270.952305.829165@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17719.8270.952305.829165@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Neil, thanks a ton.  This issue appears resolved completely, array 
creation/assembly is clean, filesystem creation and consistency checking 
is clean, and I have not generated any filesystem or md errors in 
testing yet.

Cheers,

/eli


Neil Brown wrote:
> On Wednesday October 18, estair@ilm.com wrote:
>  >
>  >
>  > I've provided the requested info, attached as two files (typescript
>  > output):
> 
> Thanks for persisting with this.
> 
> There is one bug in mdadm that is causing all of these problems.  It
> only affect the 'offset' layout with raid10.
> 
> The fix is
> http://neil.brown.name/git?p=mdadm;a=commitdiff;h=702b557b1c9
> 
> and is included below.
> You might like to grab the latest source from
>   git://neil.brown.name/mdadm
> and compile that, or just apply the patch.
> 
> Thanks again,
> NeilBrown
> 
> -------------------------
> Fix bugs related to raid10 and the new offset layout.
> 
> Need to mask of bits above the bottom 16 when calculating number of
> copies.
> 
> ### Diffstat output
>  ./ChangeLog |    1 +
>  ./Create.c  |    2 +-
>  ./util.c    |    2 +-
>  3 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff .prev/ChangeLog ./ChangeLog
> --- .prev/ChangeLog     2006-10-19 16:38:07.000000000 +1000
> +++ ./ChangeLog 2006-10-19 16:38:24.000000000 +1000
> @@ -13,6 +13,7 @@ Changes Prior to this release
>         initramfs, but device doesn't yet exist in /dev.
>      -   When --assemble --scan is run, if all arrays that could be found
>         have already been started, don't report an error.
> +    -   Fix a couple of bugs related to raid10 and the new 'offset' layout.
> 
>  Changes Prior to 2.5.4 release
>      -   When creating devices in /dev/md/ create matching symlinks
> 
> diff .prev/Create.c ./Create.c
> --- .prev/Create.c      2006-10-19 16:38:07.000000000 +1000
> +++ ./Create.c  2006-10-19 16:38:24.000000000 +1000
> @@ -363,7 +363,7 @@ int Create(struct supertype *st, char *m
>                  * which is array.size * raid_disks / ncopies;
>                  * .. but convert to sectors.
>                  */
> -               int ncopies = (layout>>8) * (layout & 255);
> +               int ncopies = ((layout>>8) & 255) * (layout & 255);
>                 bitmapsize = (unsigned long long)size * raiddisks / 
> ncopies * 2;
>  /*             printf("bms=%llu as=%d rd=%d nc=%d\n", bitmapsize, size, 
> raiddisks, ncopies);*/
>         } else
> 
> diff .prev/util.c ./util.c
> --- .prev/util.c        2006-10-19 16:38:07.000000000 +1000
> +++ ./util.c    2006-10-19 16:38:24.000000000 +1000
> @@ -179,7 +179,7 @@ int enough(int level, int raid_disks, in
>                 /* This is the tricky one - we need to check
>                  * which actual disks are present.
>                  */
> -               copies = (layout&255)* (layout>>8);
> +               copies = (layout&255)* ((layout>>8) & 255);
>                 first=0;
>                 do {
>                         /* there must be one of the 'copies' form 'first' */
> 

