From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] OLCE raid5/0 (all arrays in container)
Date: Thu, 20 Jan 2011 07:41:21 +1100
Message-ID: <20110120074121.498d2d83@notabene.brown>
References: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
	<20110117123107.58d1024e@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176EA5287@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176EA5287@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 17 Jan 2011 11:52:09 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of NeilBrown
> > Sent: Monday, January 17, 2011 2:31 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 0/6] OLCE raid5/0 (all arrays in container)
> > 
> > On Thu, 13 Jan 2011 15:50:02 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> > 
> > > The following series adds possibility to reshape all (raid0/5) arrays
> > in container for expansion feature.
> > > The main problem resolved in this series is how initialize second
> > (and next) raid0 reshapes for container reshape
> > > executed as set of array reshapes.
> > >
> > > For i.e. second raid0 array mdmon should initialize metadata to let
> > know to mdadm that there is something more to reshape.
> > > But problem is what to do when mdmon is not loaded? (for first raid0
> > array this is not a problem, reshape_super() in mdadm updates
> > metadata).
> > >
> > > this is resolved by allowing mdadm to know what was reshaped so far.
> > This allows to reshape arrays that are not reshaped yet,
> > > without update from mdmon.
> > 
> > There certainly are some complexities with reshaping a container with 2
> > RAID0
> > arrays in it.  However the approach you are taking seems too
> > complicated.
> > 
> > This is how I think the particular case of 2 RAID0 array would work.
> > It
> > should generalise neatly to all other combinations.
> > 
> > 1/ mdadm decides to proceeds with the reshape, updates the metadata
> > (because
> >    mdmon isn't running), converts the array to RAID4, starts mdmon and
> > then
> >    lets the reshape for the first array proceed.
> > 
> > 2/ when the reshape completes, mdmon will notice and will call
> >    imsm_progress_container_reshape which will update the metadata
> >    for the second array so that reshape appears to be active.
> 
> For i.e. second raid5 it is ok.
> This will never happened when second array is raid0, it is not monitored yet as arrays metadata are updated/monitored one by one.
> This means that that mdmon cannot tell (via metadata) to mdadm that next raid0 array needs to be reshaped.
> This information is used in container_content() before second takeover (in reshape_array()) is executed.

When the reshape of the first array completes, imsm_set_array_state will call
imsm_progress_container_reshape which will cause the second array to be
marked as migrating.  container_content will be able to see this and
reshape_array will be called.  It should all work.

> 
> > 
> > 3/ mdadm will convert the raid4 back to raid0 and so mdmon will exit.
> > 
> > 4/ mdadm calls container_content and finds that the second array needs
> > to
> >    be reshaped.  It converts the array to raid4 and starts mdmon.
> >    Then they oversee the reshape of the second array
> 
> Metadata for second array is not updates by mdmon as we want "now" start mdmon for it.
> 

Yes it will, it is updated at the same time that the previous array finished
the reshape.

NeilBrown


> > 
> > 5/ when the reshape completes, mdadm converts the array back to RAID0
> > and
> >    mdmon exits.
> > 
> > All done.
> 
> 
> All looks ok, except "next/2nd" raid0 array is reshaped. At "previous/1st" reshape finish, it is not monitored yet, so mdmon can't update metadata,
> before mdadm enters reshape_array() to execute takeover and then mdmon is started.
> Decision to enter reshape_array() is made based on metadata (not updated).
> 
> This is a reason why I'm using additional list for reshape decision. If mdmon doesn't make update for raid0 (not monitored)
> Mdadm tries to run mdmon for it (in reshape_array()) and waits for metadata update and decision about reshape.
> 
> Such implementation allows to follow directions for single reshape_super() call for container operation.
> 
> BR
> Adam
> 
> 
> > 
> > 
> > This should avoid almost all special-casing.
> > 
> > NeilBrown
> > 
> > 
> > >
> > > BR
> > > Adam
> > >
> > > ---
> > >
> > > Adam Kwolek (6):
> > >       FIX: sync_completed == 0 causes reshape cancellation in
> > metadata
> > >       FIX: mdadm hangs during reshape
> > >       FIX: mdadm throws coredump on exit in error case
> > >       FIX: reshape raid0 on second array
> > >       FIX: continue raid0 reshape
> > >       imsm: Update metadata for second array
> > >
> > >
> > >  Grow.c        |   95
> > +++++++++++++++++++++++++++++++++++++++++++++++++++------
> > >  monitor.c     |    4 ++
> > >  super-intel.c |   35 +++++++++++++++++++--
> > >  3 files changed, 120 insertions(+), 14 deletions(-)
> > >
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

