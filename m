From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [patch] md superblock update failures
Date: Fri, 18 Mar 2005 13:57:59 +0100
Message-ID: <nrvqg2-qsn.ln1@news.it.uc3m.es>
References: <20050316130512.GK5305@marowsky-bree.de> <16952.45067.418093.353791@cse.unsw.edu.au> <20050318103922.GB18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
> Minor cleanup:
> 
> > @@ -1325,24 +1336,24 @@ repeat:
> >  
> >               dprintk("%s ", bdevname(rdev->bdev,b));
> >               if (!rdev->faulty) {
> > -                     err += write_disk_sb(rdev);
> > +                     md_super_write(mddev,rdev,
> > +                                    rdev->sb_offset<<1, MD_SB_BYTES,
> > +                                    rdev->sb_page);
> > +                     dprintk(KERN_INFO "(write) %s's sb offset: %llu\n",
> > +                             bdevname(rdev->bdev,b),
> > +                             (unsigned long long)rdev->sb_offset);
> > +
> >               } else
> >                       dprintk(")\n");
> >               if (!err && mddev->level == LEVEL_MULTIPATH)
> >                       /* only need to write one superblock... */
> >                       break;
> >       }

Maintenance-wise, I'd prefer if (write_disk_sb(rdev) != 0) err++, since
seeing things which are of signed type tested ultimately only for
difference from zero makes me nervous. Who says somebody won't forget
the way it's tested here and let write_disk_sb one day return negative
for error, and zero for success?

> The "!err &&" part can probably go away, right?

As to your observation, morally I'm with you on that, since we oughtn't
need to write more superblocks if there has been an error than if there
hasn't.

Peter

