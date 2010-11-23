From: Neil Brown <neilb@suse.de>
Subject: Re: Autorebuild, new dynamic udev rules for hot-plugs
Date: Tue, 23 Nov 2010 16:27:54 +1100
Message-ID: <20101123162754.081dd804@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
	<66C59AD0932712458090B447266D638C0109E0E1E7@irsmsx504.ger.corp.intel.com>
	<20101122160201.24ad85f8@notabene.brown>
	<66C59AD0932712458090B447266D638C0109E6AE6C@irsmsx504.ger.corp.intel.com>
	<4CEB06BD.9090407@intel.com>
	<20101123121725.09378dc8@notabene.brown>
	<4CEB4B47.10504@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CEB4B47.10504@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On Mon, 22 Nov 2010 21:04:07 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> On 11/22/2010 5:17 PM, Neil Brown wrote:
> > On Mon, 22 Nov 2010 16:11:41 -0800
> > Dan Williams<dan.j.williams@intel.com>  wrote:
> >
> >> On 11/22/2010 3:50 PM, Hawrylewicz Czarnowski, Przemyslaw wrote:
> >>>> Four comments.
> >>>>
> >>>> 1/ I wouldn't write a file in /lib/udev/rules.d/
> >>>>     I think it should be written to "/dev/.udev/rules.d/"
> >>>>     which is referred to as the "temporary rules directory"
> >>>>     in the udev documentation.
> >>> I am not sure if it is what we are looking for. Temporary means they disappear after reboot. It is OK as cold-plug does not need support for bare disks (or maybe I am wrong?). But in such case, one who wants to use autorebuild should invoke mdadm --activate-domains for example in /etc/init.d/local.boot or somewhere else. Second idea here is to use ActivateDomain() when one starts monitor with autorebuild enabled. Which one? I would prefer to leave it as it was written initially (considering comment #4). Then, if one removes policies from config, invoking --activate-domains should reset/remove rules (but see #3)
> >>
> >> The intent was always to have this be something reinitialized at boot.
> >> Putting these in the temporary rule directory also precludes them from
> >> being added to the initramfs where they are not needed / potentially
> >> confusing.
> >>
> >> The other intent was to only match the pci paths for the controllers we
> >> cared about.  That does not appear to be a part of this patch.
> >
> > Can you define "we cared about".  Don't we care about everything listed in
> > mdadm.conf??
> 
> A hot plug event outside of ahci (in raid mode), or the upcoming isci 
> driver needs to be ignored and an error thrown on activate if we can 
> unambiguously determine that the domain defines firmware unreachable 
> devices.


I can agree that a hot plug event for a non-firmware-reachable device should
not cause that device to be added to an imsm array.  But the domain setting
should stop that happening already.

I don't agree (as I *think* you are saying) that hot plug events on such
devices should be completely ignored by mdadm.  But as I am very surprised
that you would say that, I suspect I'm misunderstanding.


NeilBrown




> 
> The IMSM_NO_PLATFORM debug environment variable can override this 
> behavior, or in the ahci case you can run in raid disabled mode.  I need 
> to check if the same raid disabled case holds for isci.
> 
> >
> > We could avoid both these issues by just writing the new rules file to stdout.
> > When when the init script gets it wrong, it isn't our fault :-)
> >
> > But I don't really like that.  At least there should be a simple and uniform
> > way to propagate any mdadm.conf changes into udev.
> >
> > Maybe the name of the rules file should be given in mdadm.conf, and e.g.
> >    mdadm --check-config
> > would report any syntax errors, report any inconsistencies with current
> > arrays, and update the udev file if necessary..
> >
> > Maybe leave that for 3.2.1, and just support '--activate-domains=filename'
> > for now.
> >
> > ???
> 
> A more generic mdadm.conf checker sounds like a good idea in general.
> 
> --
> Dan

