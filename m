From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] fix: do not overwrite existing devices' symlinks
Date: Tue, 31 Jan 2012 08:00:50 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB07BE50@IRSMSX102.ger.corp.intel.com>
References: <20120123120652.20165.47998.stgit@gklab-128-085.igk.intel.com>
	<20120130122728.3aa8da9a@notabene.brown>
	<D9FFE20C522965449E182ACE73889AEB07067C@IRSMSX101.ger.corp.intel.com>
 <20120131091357.18fa2b75@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120131091357.18fa2b75@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, January 30, 2012 11:14 PM
> To: Dorau, Lukasz
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Labun, Marcin; Ciechanowski,
> Ed
> Subject: Re: [PATCH] fix: do not overwrite existing devices' symlinks
> 
> On Mon, 30 Jan 2012 12:13:05 +0000 "Dorau, Lukasz"
> <lukasz.dorau@intel.com>
> wrote:
> 
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Monday, January 30, 2012 2:27 AM
> > > To: Dorau, Lukasz
> > > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Labun, Marcin;
> Ciechanowski,
> > > Ed
> > > Subject: Re: [PATCH] fix: do not overwrite existing devices' symlinks
> > >
> > > On Mon, 23 Jan 2012 13:06:52 +0100 Lukasz Dorau
> <lukasz.dorau@intel.com>
> > > wrote:
> > >
> > > > If the device's name is given in /etc/mdadm.conf, create_mddev()
> > > > does not check if the map contains a device of this name (mdopen.c:140).
> > > > If it does, the symlink of that name will be overwritten.
> > > >
> > > > create_mddev() has been changed. Now it checks if the map contains
> > > > a device of the name given in /etc/mdadm.conf.
> > > > If it does, the appropriate suffix is added to the given name.
> > > >
> > > > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> > >
> > > Can you please remind me what the big picture problem is here??
> > >
> > > It seem like you are suggesting that if
> > >    /dev/md/thing
> > >
> > > is given in mdadm.conf, but some other array is already assembled with the
> > > name /dev/md/thing, then the array from mdadm.conf should be assembled
> as
> > >    /dev/md/thing0
> > > or something like that - is that correct?
> > >
> > > I don't think we want that.  If there is a name conflict like  this with a
> > > name given in mdadm.conf, then one of the arrays should fail to assemble as
> > > this is really a fairly serious configuration error.
> > >
> > > Or did I misunderstand?
> > >
> >
> >
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Monday, January 30, 2012 2:30 AM
> > > To: Dorau, Lukasz
> > > Subject: Re: mdadm: checking dev's names from mdadm.conf - question
> > >
> > > On Fri, 20 Jan 2012 09:27:58 +0000 "Dorau, Lukasz"
> <lukasz.dorau@intel.com>
> > > wrote:
> > >
> > > > Hi
> > > >
> > > > Is it OK that mdadm does not check if a symlink of the name given in
> > > /etc/mdadm.conf already exists (in function create_mddev() in
> mdopen.c:140) ?
> > > >
> > > > For example:
> > > > If we modify the original /etc/mdadm.conf file:
> > > >
> > > > ARRAY metadata=imsm UUID=e92bcf10:ca6b3fbd:95904441:5472d320
> > > > ARRAY /dev/md/vol1 container=e92bcf10:ca6b3fbd:95904441:5472d320
> > > member=0 UUID=ea776aa6:4691d6ee:9400457e:73e1e9d9
> > > > ARRAY metadata=imsm UUID=d61a8e6a:ed4e8ed6:dc0f4fb7:f839907e
> > > > ARRAY /dev/md/vol2 container=d61a8e6a:ed4e8ed6:dc0f4fb7:f839907e
> > > member=0 UUID=b33bbd5e:964c7acc:66cfdfcc:7a938902
> > > >
> > > > by adding the 2nd container 's name /dev/md/imsm0 to the 3rd line:
> > > >
> > > > ARRAY metadata=imsm UUID=e92bcf10:ca6b3fbd:95904441:5472d320
> > > > ARRAY /dev/md/vol1 container=e92bcf10:ca6b3fbd:95904441:5472d320
> > > member=0 UUID=ea776aa6:4691d6ee:9400457e:73e1e9d9
> > > > ARRAY /dev/md/imsm0 metadata=imsm
> > > UUID=d61a8e6a:ed4e8ed6:dc0f4fb7:f839907e
> > > > ARRAY /dev/md/vol2 container=d61a8e6a:ed4e8ed6:dc0f4fb7:f839907e
> > > member=0 UUID=b33bbd5e:964c7acc:66cfdfcc:7a938902
> > > >
> > > > mdadm will create the first container /dev/md127 and the symlink of
> default
> > > name /dev/md/imsm0 (and the first volume /dev/md126 with symlink
> > > /dev/md/vol1).
> > > > Later it will create the second container /dev/md125 and the symlink of the
> > > name given in /etc/mdadm.conf - /dev/md/imsm0 - the same as the name of
> > > the first container.
> > > >
> > > > Mdadm does not check if the symlink of the given name already exists and
> it
> > > _overwrites_ the first symlink. Is it OK or maybe should it be corrected?
> > > >
> > >
> > > Ahhh.. this is where the big-picture bit is...
> > >
> > > I don't have a big problem with it over-writing the symlink - that is what
> > > you asked for in a way.
> > >
> > > However I also wouldn't have a problem with mdadm refusing the assemble
> the
> > > second container as its name is already in use.
> > >
> >
> >
> > So, are you going to apply this patch or do you want it to be fixed in another
> way?
> 
> The approaches I said were OK were:
>   1/ over-write the symlink
>   2/ refuse to assemble the second container
> 
> The approach the patch takes is
>   3/ use a different name to the one in mdadm.conf
> 
> As 3 != 1 and 3 != 2, I'm not going to apply the patch.
> 

OK, I had misunderstood you previously.

Regards,
Lukasz

