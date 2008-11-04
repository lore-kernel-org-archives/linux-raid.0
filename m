From: greg@enjellic.com
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 4 Nov 2008 09:36:51 -0600
Message-ID: <200811041536.mA4FapG5014950@wind.enjellic.com>
References: <neilb@suse.de>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: Neil Brown <neilb@suse.de>
       "Re: RFC - device names and mdadm with some reference to udev." (Oct 31,  8:18pm)
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, greg@enjellic.com
Cc: Doug Ledford <dledford@redhat.com>, martin f krafft <madduck@debian.org>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Oct 31,  8:18pm, Neil Brown wrote:
} Subject: Re: RFC - device names and mdadm with some reference to udev.

Hi Neil, et. al, hope your day has started well.

> On Thursday October 30, greg@enjellic.com wrote:
> > Whatever we do please do not make use of mdadm or startup of arrays
> > dependent on udev.  I do SAN's for a living and have had far too many
> > phone calls and have spent too much time trying to get boxes messed up
> > by udev back on the fabric to want to add any more complication to the
> > mix.

> I had intended to continue to support the no-udev installations, but
> thank you the encouragement that it really is needed and will be
> used.
>
> Just a clarification: are you envisaging an installation without
> udev at all, or one with udev installed and active, but you don't
> wont mdadm to depend on it?  That latter option may be more awkward
> (I currently support an environment variable which says "just create
> the devices, even if udev appears to be installed").

On the really critical systems I supervise there is no presence of
udev at all.  We need mdadm to run in that type of environment.

I guess if mdadm finds udev active and running it should feel free to
cooperate with it.  If there is an option to tell mdadm to create the
devices itself or use what has been defined that would be very helpful
as well and something we would use.

We find real problems with udev race issues in wide area SAN
implementations.  We had an incident a couple of weeks ago which
caused filesystem problems and a significant outage period secondary
to non-deterministic device setup in a udev based environment.

Our primary goals are simple, uncomplicated and reliable.

> > The notion of udev certainly has its place but not on a server which
> > only cares about four device nodes for its entire operational life.
> > 
> > Neil your mdadm is a great tool and your contributions via the MD
> > stuff are beyond peer, keep up the good work.  But this stuff has to
> > get simpler rather than more complex.
> 
> Thanks :-)
> 
> NeilBrown

Keep up the good work, best wishes for a productive week.

}-- End of excerpt from Neil Brown

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"More people are killed every year by pigs than by sharks, which shows
 you how good we are at evaluating risk."
                                -- Bruce Schneier
                                   Beyond Fear
