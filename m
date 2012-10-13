From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-6 problem
Date: Sat, 13 Oct 2012 23:22:13 +0200
Message-ID: <20121013212212.GA15542@lazy.lzy>
References: <20121013120328.GA23279@lazy.lzy>
 <alpine.DEB.2.00.1210131919230.21297@uplift.swm.pp.se>
 <mepok9xf4q.ln2@goaway.wombat.san-francisco.ca.us>
 <20121014063102.0755820b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121014063102.0755820b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Keith Keller <kkeller@wombat.san-francisco.ca.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 14, 2012 at 06:31:02AM +1100, NeilBrown wrote:
> On Sat, 13 Oct 2012 11:45:10 -0700 Keith Keller
> <kkeller@wombat.san-francisco.ca.us> wrote:
> 
> > On 2012-10-13, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> > >
> > > Re-creating a raid5/6 with --assume-clean is for me a disaster recovery, 
> > > something that should be performed when everything else fails. It's 
> > > extremely unfortunate that a lot of guides bring this in very early in the 
> > > fault finding process.
> > 
> > Actually the RAID wiki suggests exactly this path, and suggests against
> > --force, contrary to the advice I've gotten here from Neil and others.
> > 
> > https://raid.wiki.kernel.org/index.php/RAID_Recovery#Restore_array_by_recreating_.28after_multiple_device_failure.29
> > 
> > I could update this, but not being expert all it'd say is "use
> > --assemble --force; if it fails ask on the mailing list."  :)  Perhaps
> > that's actually the best advice to give, but if there's something more
> > useful to put on that page maybe someone with more expertise could
> > update it?
> > 
> > --keith
> > 
> 
> 
> You should definitely try '--assemble --force' before trying to recreate the
> array.  There is no question about that.

Thanks to everybody,

The "-A --force" worked fine, the array had, in the
end, 0 mismatch count.

Thanks again,

bye,

pg

> 
> NeilBrown



-- 

piergiorgio
