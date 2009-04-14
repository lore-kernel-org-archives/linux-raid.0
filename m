From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Tue, 14 Apr 2009 11:12:52 +1000
Message-ID: <18915.58132.90607.907792@notabene.brown>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com>
	<87tz51dmmu.fsf@frosties.localdomain>
	<FF2073B4-6922-4D16-8FA7-90C66071C6F6@redhat.com>
	<155bf3edda1c2692d316807ff5f58f30.squirrel@neil.brown.name>
	<87prfof1bp.fsf@frosties.localdomain>
	<18908.17619.375078.291547@notabene.brown>
	<B440D9C9-91D6-4491-A3AF-D9E1478EDBA9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Thursday April 9
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday April 9, dledford@redhat.com wrote:
> On Apr 8, 2009, at 2:31 AM, Neil Brown wrote:
> > I'm leaning towards:
> >
> > - to open for reading, if /var/run/mdadm/map doesn't exist,
> >   try /dev/.mdadm.map
> > - to open for writing, if opening /var/run/mdadm/map and
> >   /var/run/mdadm.map for writing fails, try /dev/.mdadm.map
> >
> > Note that I don't want to put the file in /dev/md/ as that might not
> > exist yet either.
> >
> > So the idea is to still use /var/run/mdadm{.,/}map, but fall back on
> > /dev/.mdadm.map if that is the only option.
> >
> > Thought?
> 
> Fine with me.

Cool.  It is done now and pushed out.

Thanks,
NeilBrown
