From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [patch] md superblock update failures
Date: Fri, 18 Mar 2005 11:39:22 +0100
Message-ID: <20050318103922.GB18819@marowsky-bree.de>
References: <20050316130512.GK5305@marowsky-bree.de> <16952.45067.418093.353791@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <16952.45067.418093.353791@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-17T09:15:39, Neil Brown <neilb@cse.unsw.edu.au> wrote:

> Yes... thanks....
> The whole '100 times' thing is completely bogus isn't it...

Yes.

> By co-incidence, I've just recently be modifying this code to do
> writes more intelligently.  My goal was to get it to write all the
> superblocks in parallel rather than in series.  The result is below
> which will probably go to Andrew shortly.  It add the required
> md_error and removes the 'try 100 times'.
> It also loops 'round to re-write the superblock if one of the writes
> failed, thus dirtying the superblock.

Your patch is much cleaner and nicer. I'll pick that up when it goes to
Andrew.

Minor cleanup:

> @@ -1325,24 +1336,24 @@ repeat:
> =20
>  		dprintk("%s ", bdevname(rdev->bdev,b));
>  		if (!rdev->faulty) {
> -			err +=3D write_disk_sb(rdev);
> +			md_super_write(mddev,rdev,
> +				       rdev->sb_offset<<1, MD_SB_BYTES,
> +				       rdev->sb_page);
> +			dprintk(KERN_INFO "(write) %s's sb offset: %llu\n",
> +				bdevname(rdev->bdev,b),
> +				(unsigned long long)rdev->sb_offset);
> +
>  		} else
>  			dprintk(")\n");
>  		if (!err && mddev->level =3D=3D LEVEL_MULTIPATH)
>  			/* only need to write one superblock... */
>  			break;
>  	}

The "!err &&" part can probably go away, right?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
