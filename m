From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 10/36] md/raid1: avoid writing to known-bad blocks on
 known-bad drives.
Date: Wed, 27 Jul 2011 14:19:41 +1000
Message-ID: <20110727141941.13d9bc35@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025848.8422.25836.stgit@notabene.brown>
	<87vcuogyak.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vcuogyak.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Jul 2011 13:09:07 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > If we have seen any write error on a drive, then don't write to
> > any known-bad blocks on that drive.
> > If necessary, we divide the write request up into pieces just
> > like we do for reads, so each piece is either all written or
> > all not written to any given drive.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> 
> Reviewed-by: Namhyung Kim <namhyung@gmail.com>
> 
> and a nit below
> 

> > -		} else
> > -			r1_bio->bios[i] = NULL;
> > +			if (is_bad) {
> > +				int good_sectors = first_bad - r1_bio->sector;
> > +				if (good_sectors < max_sectors)
> > +					max_sectors = good_sectors;
> > +			}
> > +		}
> > +		r1_bio->bios[i] = bio;
> > +		targets++;
> 
> Looks like variable 'targets' is not needed anymore.
> 
> 

Thanks.  I've removed it.

NeilBrown

