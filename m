From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] md: raid10: remove VLAIS
Date: Thu, 5 Oct 2017 17:19:17 -0700
Message-ID: <20171006001917.GQ173745@google.com>
References: <20171005182847.3368-1-mka@chromium.org>
 <87k209170c.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k209170c.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Michael Davidson <md@google.com>, Guenter Roeck <groeck@chromium.org>
List-Id: linux-raid.ids

Hi Neil,

El Fri, Oct 06, 2017 at 10:58:59AM +1100 NeilBrown ha dit:

> On Thu, Oct 05 2017, Matthias Kaehlcke wrote:
> 
> > The raid10 driver can't be built with clang since it uses a variable
> > length array in a structure (VLAIS):
> >
> > drivers/md/raid10.c:4583:17: error: fields must have a constant size:
> >   'variable length array in structure' extension will never be supported
> >
> > Allocate the r10bio struct with kmalloc instead of using the VLAIS
> > construct.
> >
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> >  drivers/md/raid10.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 374df5796649..9616163eaf8c 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -4578,15 +4578,16 @@ static int handle_reshape_read_error(struct mddev *mddev,
> >  	/* Use sync reads to get the blocks from somewhere else */
> >  	int sectors = r10_bio->sectors;
> >  	struct r10conf *conf = mddev->private;
> > -	struct {
> > -		struct r10bio r10_bio;
> > -		struct r10dev devs[conf->copies];
> > -	} on_stack;
> > -	struct r10bio *r10b = &on_stack.r10_bio;
> > +	struct r10bio *r10b;
> >  	int slot = 0;
> >  	int idx = 0;
> >  	struct page **pages;
> >  
> > +	r10b = kmalloc(sizeof(*r10b) +
> > +	       sizeof(struct r10dev) * conf->copies, GFP_KERNEL);
> 
> GFP_KERNEL isn't a good idea here.
> This could wait for writeback, and if writeback tries to write to the
> region of the array which is being reshaped, it might deadlock.
> 
> GFP_NOIO is safer.

Good point, thanks!

> given that conf->copies is almost always 2 it might be nicer to
> have
> 
> 	struct {
> 		struct r10bio r10_bio;
> 		struct r10dev devs[2];
> 	} on_stack;
> 
>         struct r10bio *r10b;
> 
> 	if (conf->copies <= ARRAY_SIZE(on_stack.devs))
>         	r10b = &on_stack.r10_bio;
>         else
>         	r10b = kmalloc(sizeof(*r10b) +
> 			       sizeof(struct r10dev) * conf->copies, GFP_NOIO);

It would add also add an extra condition to determine if r10b needs to
be freed or not.

Given that array reshaping is a rare operation and an error during
this operation is an exceptional condition I think the simpler code
with always dynamic allocation is preferable. That said I'm fine with
reworking the patch according to your suggestion if you or Shaohua
prefer it.

Matthias

> > +	if (!r10b)
> > +		return -ENOMEM;
> > +
> >  	/* reshape IOs share pages from .devs[0].bio */
> >  	pages = get_resync_pages(r10_bio->devs[0].bio)->pages;
> >  
> > @@ -4635,11 +4636,13 @@ static int handle_reshape_read_error(struct mddev *mddev,
> >  			/* couldn't read this block, must give up */
> >  			set_bit(MD_RECOVERY_INTR,
> >  				&mddev->recovery);
> > +			kfree(r10b);
> >  			return -EIO;
> >  		}
> >  		sectors -= s;
> >  		idx++;
> >  	}
> > +	kfree(r10b);
> >  	return 0;
> >  }
> >  


