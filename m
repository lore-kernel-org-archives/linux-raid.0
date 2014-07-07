From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: RE: [PATCH] Grow: Do not use grow-continue unit file if reshape is
 starting
Date: Mon, 7 Jul 2014 14:18:40 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F19CC0918@IRSMSX105.ger.corp.intel.com>
References: <84A53BEA6EAC69439B7E311E9B17A76F19CC0430@IRSMSX105.ger.corp.intel.com>
 <20140707110613.3b558b33@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140707110613.3b558b33@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

> On Monday, July 07, 2014 3:06 AM Neil Brown wrote:
> To: Baldysiak, Pawel
> Cc: linux-raid@vger.kernel.org; Paszkiewicz, Artur
> Subject: Re: [PATCH] Grow: Do not use grow-continue unit file if reshape is
> starting
> 
> On Fri, 4 Jul 2014 08:59:00 +0000 "Baldysiak, Pawel"
> <pawel.baldysiak@intel.com> wrote:
> 
> > Mdadm should use mdadm-grow-continue unit file only if reshape is
> > going to be continued. Otherwise, array specific reshape with IMSM
> > metadata will fail to start, due to missing information about ongoing
> > migration - grow-continue will try to start again the reshape process.
> 
> I don't think I agree.  I think mdadm should always use mdadm-grow-
> continue unit file if it is available.
> 
> Please explain in more detail what problem you are seeing.
> 
> NeilBrown
> 

Hi Neil

If we try to do array-specific reshape (e.g. change from level 0 to 5) 
mdadm will impose all changes to metadata and start reshape - before running grow-continue.
After that  grow-continue will see that reshape progress is '0', so will overwrite "restart" by setting it to =0.
Then it will try to impose all changes again and fail - with error:
"Cannot set device shape for /dev/md/vol" - It will be unable to write changes to sysfs,
due to already started reshape (which freeze at '0' progress).

We can try to fix it by moving part of code that runs grow-continue in reshape_array earlier,
 so "start_reshape() " will be executed by grow-continue (I am testing that kind of patch now), 
or forbid running grow-continue when reshape is about to start (patch is tested, attach in my prev mail).

What do you think about that?
Do you have any other idea how to fix this issue?

Thanks
Pawel Baldysiak

> >
> > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > ---
> >  Grow.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index a2f4f14..0cd9442 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -3272,7 +3272,7 @@ started:
> >  		return 1;
> >  	}
> >
> > -	if (!forked && !check_env("MDADM_NO_SYSTEMCTL"))
> > +	if (restart && !forked && !check_env("MDADM_NO_SYSTEMCTL"))
> >  		if (continue_via_systemd(container ?: sra->sys_name)) {
> >  			free(fdlist);
> >  			free(offsets);

