From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 10/10] FIX: wait_backup() sometimes hungs
Date: Fri, 3 Dec 2010 07:45:14 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174CCC3BA@irsmsx503.ger.corp.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
	<20101202081958.4639.17010.stgit@gklab-170-024.igk.intel.com>
 <20101203151655.04e48dff@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101203151655.04e48dff@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

I think you applied not a whole patch (no 't' definition and initialization), you missed:

+		struct timeval t;
+
+		t.tv_sec = 1;
+		t.tv_usec = 0;

so mdadm is not compiling

BR
Adam

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Friday, December 03, 2010 5:17 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 10/10] FIX: wait_backup() sometimes hungs
> 
> On Thu, 02 Dec 2010 09:19:58 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > Sometimes wait_backup() omits transition from reshape to iddle state
> and mdadm seams to be hung.
> > Add 1 sec. timeout wor waiting on select. This allows for wait_backup
> exit when reshape is ended.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Grow.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 24c5c39..e16b1ad 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -2074,10 +2074,14 @@ static int wait_backup(struct mdinfo *sra,
> >  		sysfs_set_str(sra, NULL, "sync_action", "reshape");
> >  	do {
> >  		char action[20];
> > +		struct timeval t;
> > +
> > +		t.tv_sec = 1;
> > +		t.tv_usec = 0;
> >  		fd_set rfds;
> >  		FD_ZERO(&rfds);
> >  		FD_SET(fd, &rfds);
> > -		select(fd+1, NULL, NULL, &rfds, NULL);
> > +		select(fd+1, NULL, NULL, &rfds, &t);
> >  		if (sysfs_fd_get_ll(fd, &completed) < 0) {
> >  			close(fd);
> >  			return -1;
> 
> 
> Thanks.  However I don't think the 1 second timeout is necessary.  This
> is
> really the same problem as the previous one.  We just need to read
> 'completed' before the first 'select'.  Like this.
> 
> Thanks,
> NeilBrown
> 
> commit 97bef35459306dfd291f40bc5221ad20ab9c21ba
> Author: Adam Kwolek <adam.kwolek@intel.com>
> Date:   Fri Dec 3 15:15:51 2010 +1100
> 
>     FIX: wait_backup() sometimes hungs
> 
>     Sometimes wait_backup() omits transition from reshape to idle state
>     and mdadm seams to be hung.  So check the 'complete' count
>     *before* waiting rather than only after.
> 
>     Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/Grow.c b/Grow.c
> index 3322cf7..99807b4 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2058,12 +2058,17 @@ static int wait_backup(struct mdinfo *sra,
>  	sysfs_set_num(sra, NULL, "sync_max", offset + blocks + blocks2);
>  	if (offset == 0)
>  		sysfs_set_str(sra, NULL, "sync_action", "reshape");
> -	do {
> +
> +	if (sysfs_fd_get_ll(fd, &completed) < 0) {
> +		close(fd);
> +		return -1;
> +	}
> +	while (completed < offset + blocks) {
>  		char action[20];
>  		fd_set rfds;
>  		FD_ZERO(&rfds);
>  		FD_SET(fd, &rfds);
> -		select(fd+1, NULL, NULL, &rfds, NULL);
> +		select(fd+1, NULL, NULL, &rfds, &t);
>  		if (sysfs_fd_get_ll(fd, &completed) < 0) {
>  			close(fd);
>  			return -1;
> @@ -2072,7 +2077,7 @@ static int wait_backup(struct mdinfo *sra,
>  				  action, 20) > 0 &&
>  		    strncmp(action, "reshape", 7) != 0)
>  			break;
> -	} while (completed < offset + blocks);
> +	}
>  	close(fd);
> 
>  	if (part) {
