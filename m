From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
 unsupported metadata
Date: Mon, 31 Oct 2011 16:52:22 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D4043D80@IRSMSX101.ger.corp.intel.com>
References: <F9123E44003394499FDD2B17C60621D4043755@IRSMSX101.ger.corp.intel.com>
 <20111031113151.64f566b1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111031113151.64f566b1@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, October 31, 2011 1:32 AM
> To: Labun, Marcin
> Cc: linux-raid@vger.kernel.org; Williams, Dan J
> Subject: Re: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
> unsupported metadata
> 
> On Fri, 28 Oct 2011 14:46:57 +0000 "Labun, Marcin"
> <Marcin.Labun@intel.com>
> wrote:
> 
> > Hi Neil,
> > Please review modified patch in response for your comments.
> > I have introduced two flags, one for activation blocking, second for
> > container wide reshapes
> > Blocking:
> > - some arrays in container are blocked, the others can be activated
> > and reshaped,
> > - some arrays are blocked, others can be activated but container wide
> reshaped is blocked for all.
> >
> > Thanks,
> > Marcin Labun
> 
> Thanks.  This looks mostly OK.
> I have applied it -  with a number of formatting improvements and the
> removal for a debugging printf :-)

Thanks!
It seems that map_lock call appeared from *nowhere* in the modified patch :). Please see the context below.

-	/* do not assemble arrays that might have bad blocks */
-	if (list && list->array.state & (1<<MD_SB_BBM_ERRORS)) {
-		fprintf(stderr, Name ": BBM log found in metadata. "
-					"Cannot activate array(s).\n");
-		/* free container data and exit */
-		sysfs_free(list);
-		return 2;
-	}
-
+	/* when nothing to activate - quit */
+	if (list == NULL)
+		return 0;
+	if (map_lock(&map))
+		fprintf(stderr, Name ": failed to get exclusive lock on "
+			"mapfile\n");

> 
> However this bit looks wrong:
> 
> > +/*
> > + * helper routine to check metadata reshape avalability
> > + * 1. Do not "grow" arrays with volume activation blocked
> > + * 2. do not reshape containers with container reshape blocked
> > + *
> > + * IN:
> > + *	subarray - array name or NULL for container wide reshape
> > + *	content - md device info from container_content
> > + * OUT:
> > + *	0 - block reshape
> > + */
> > +static int check_reshape(char *subarray, struct mdinfo *content) {
> > +	char *ep;
> > +	unsigned int idx;
> > +	printf("subarray: %s\n", subarray);
> > +
> > +
> > +	if (!subarray) {
> > +		if (content->array.state &
> (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))
> > +			return 0;
> > +	}
> > +	else {
> > +		/* do not "grow" arrays with volume activation blocked */
> > +		idx = strtoul(subarray, &ep, 10);
> > +		if ((*ep == '\0') && (content->container_member == (int)
> idx) &&
> > +		    (content->array.state & (1<<MD_SB_BLOCK_VOLUME)))
> > +			return 0;
> > +	}
> > +
> > +	return 1;
> > +}
> 
> Grow.c shouldn't be doing a 'strtoul' here.  The subarray string
> belongs to the metadata handler, mdadm core code shouldn't interpret it
> at all.
> 
> What exactly is the point of that bit of code?
> 
> Thanks,
> NeilBrown
Grow.c generates subarray string in super_by_fd() function.Derived from (struct mdinfo) sra->text_version.

In check_reshape function I want to know on which subarray grow operates to get subarray blocking bits.
Thanks,
Marcin Labun





