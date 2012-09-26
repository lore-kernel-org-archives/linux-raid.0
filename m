From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] fix: imsm: mdmon should reread component_size on wakeup
Date: Wed, 26 Sep 2012 12:22:35 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1900D756@IRSMSX102.ger.corp.intel.com>
References: <20120917083755.26592.53269.stgit@gklab-128-085.igk.intel.com>
	<20120920113057.70de3a65@notabene.brown>
	<D9FFE20C522965449E182ACE73889AEB1900CD88@IRSMSX102.ger.corp.intel.com>
 <20120926105912.268605b7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926105912.268605b7@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
List-Id: linux-raid.ids

On Wednesday, September 26, 2012 2:59 AM NeilBrown <neilb@suse.de> wrote:
> 
> On Tue, 25 Sep 2012 09:08:45 +0000 "Dorau, Lukasz"
> <lukasz.dorau@intel.com> wrote:
> 
> > On Thursday, September 20, 2012 3:31 AM NeilBrown <neilb@suse.de>
> wrote:
> > > On Mon, 17 Sep 2012 10:37:55 +0200 Lukasz Dorau
> > > <lukasz.dorau@intel.com> wrote:
> > >
> > > > Mdmon has not read component_size (in read_and_act()) on wakeup
> so
> > > far.
> > > > In case of size's expansion component_size has been changed but
> > > > mdmon has not updated it. As a result the metadata was incorrect
> > > > during the size's expansion. It has contained no information
> > > > that resync was in progress (there has been no checkpoint too).
> > > > The metadata has been as if resync has already been finished
> > > > but it has not.
> > > >
> > > > Updating of component_size has been added to read_and_act().
> > > > Now mdmon uses the correct value of component_size and the correct
> > > > metadata (containing information about resync and checkpoint) is
> written.
> > >
> > > Thanks, but I don't think I like this approach.
> > >
> > > In my mind, the 'monitor' thread should only be monitoring things that it
> has
> > > to respond to quickly - before another write can complete.
> > > A size change does not need to be so immediate.
> > > So I would rather that mdadm updates component_size but not
> array_size,
> > > and
> > > then 'ping's the manager.   The manager thread then checks and notices
> that
> > > the component size has changed, asks the monitor to update the
> metadata,
> > > then
> > > sets the array_size to match.
> > >
> > > Possibly mdadm shouldn't just 'ping' the monitor, but should send the
> > > metadata update ... not sure which is best.
> > >
> > > Does that make sense to you?
> > >
> >
> > Maybe the description of the patch was a bit misleading and I suppose
> > that you have misunderstood me.
> > mdadm changes (updates) "component_size", not mdmon. The only thing
> > this patch adds is that mdmon rereads the value of "component_size" on
> wakeup
> > in case it has been changed by mdadm in meantime. So far mdmon has
> read
> > "component_size" only once on startup. It was wrong, because if
> "component_size"
> > has been changed by mdadm (in case of size's expansion), mdmon was
> using wrong,
> > old value of "component_size". This patch corrects that.
> > Is it OK for you?
> 
> That is exactly what I understood you to mean.  But I don't agree with it.
> 
> It isn't the job of the monitor thread to notice geometry changes.  That is
> the job of the manager thread, possibly being told by mdadm via the socket.
> The manager should explicitly tell the the monitor to perform a metadata
> update when the size changes.
> The monitor doesn't monitor chunksize or level or any other part of th
> geometry of the array, and it shouldn't monitor component_size either.
> 
OK, thanks for explanation.

Lukasz

