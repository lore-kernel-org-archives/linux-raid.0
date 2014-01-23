From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] raid6check.c add page size check and repair
Date: Thu, 23 Jan 2014 19:40:04 +0100
Message-ID: <20140123184004.GA9455@lazy.lzy>
References: <20140118181823.GA15757@lazy.lzy>
 <52DD4ABD.5060605@itwm.fraunhofer.de>
 <20140120182223.GA4871@lazy.lzy>
 <20140120191022.GA8006@lazy.lzy>
 <20140123123058.72f07aa7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140123123058.72f07aa7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 23, 2014 at 12:30:58PM +1100, NeilBrown wrote:
> On Mon, 20 Jan 2014 20:10:22 +0100 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Hi again,
> > 
> > I'm polluting the mailing list now... Sorry!
> > 
> > I found a couple of really stupid bugs, so this
> > re-re-patch should fix them.
> > 
> > Sorry for the noise.
> > 
> 
> Hi,
>  I've applied that patch - it looks believable.
> 
> However:
> 1/ If you could try putting a description of what the patch does, and why, at
> the top, that would help a lot.
> See  http://www.ozlabs.org/~akpm/stuff/tpp.txt
> 
> 2/  I'm not really happy about:
> > @@ -217,26 +231,31 @@ int check_stripes(struct mdinfo *info, i
> >  		block_index_for_slot[diskP] = data_disks;
> >  		blocks[data_disks+1] = stripes[diskQ];
> >  		block_index_for_slot[diskQ] = data_disks+1;
> > -
> > +/* Do we really need the code below? */
> > +#if 0
> >  		if (memcmp(p, stripes[diskP], chunk_size) != 0) {
> >  			printf("P(%d) wrong at %llu\n", diskP, start);
> >  		}
> >  		if (memcmp(q, stripes[diskQ], chunk_size) != 0) {
> >  			printf("Q(%d) wrong at %llu\n", diskQ, start);
> >  		}
> > +#endif
> 
> 
> If you think it should be removed, then delete it completely.  It will still
> exist in the git history so they is no really loss of code.
> If you aren't sure, then don't delete it at all.  Ask.  Explain your thinking
> and seek opinions.
> In either case it should be in a separate patch.
> I've left the "#if 0" etc for now but if you could push through to a
> resolution and send a patch I would appreciate it.

Hi Neil,

thanks for your review and comments.

I'll send a patch (separate email)
removing the code.

bye,

> 
> Thanks,
> NeilBrown



-- 

piergiorgio
