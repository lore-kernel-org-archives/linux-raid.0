From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: [PATCH/RFC] md/raid10: optimize read_balance() for 'far copies' arrays
Date: Wed, 8 Jun 2011 13:49:25 +0200
Message-ID: <20110608114924.GA10134@www2.open-std.org>
References: <1307516445-3208-1-git-send-email-namhyung@gmail.com> <20110608172157.4d6ac2a8@notabene.brown> <877h8w93bw.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877h8w93bw.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 08, 2011 at 04:42:27PM +0900, Namhyung Kim wrote:
> NeilBrown <neilb@suse.de> writes:
> 
> > On Wed,  8 Jun 2011 16:00:45 +0900 Namhyung Kim <namhyung@gmail.com> wrote:
> >
> >> If @conf->far_offset > 0, there is only 1 stripe so that we can treat
> >> the array same as 'near' arrays. Furthermore we could calculate new
> >> distance from the previous position even for the real 'far' array
> >> cases if the position of given disk is already in the lowest stripe.
> >> 
> > I agree that it still make sense to to balancing if far_offset != 0.
> > However  there is absolutely no point in your change to the calculation of
> > new_distance.
> > You only wont new_distance to contain a distance from head position if we
> > want to choose the device with the 'closest' head.  But we don't.  We want to
> > choose the device were the data is closest to the start of the device.  So
> > the current value for new_distance is correct.
> >
> 
> Still can't understand why we choose the closest-to-the-start disk in
> case we could have possible sequencial access on other disk. Probably
> because of the lack of my understanding how md/disk works :(

the nearest position was the case for the initial implementation of
raid10-far.  But this had bad performance for an array with disks of
varying specifications. And also it led to not using the faster
outer sectors. Using the closest-to-beginning gave a spped-up of about
50 % in some cases.

best regards
keld
