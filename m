From: greg@enjellic.com
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Thu, 12 Nov 2009 11:51:22 -0600
Message-ID: <200911121751.nACHpMrQ011365@wind.enjellic.com>
References: <nfbrown@novell.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: "Neil F Brown" <nfbrown@novell.com>
       "Re: [ANNOUNCE] mdadm-3.1 has been withdrawn" (Nov 10,  7:22am)
Sender: linux-raid-owner@vger.kernel.org
To: Neil F Brown <nfbrown@novell.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Nov 10,  7:22am, "Neil F Brown" wrote:
} Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn

Good morning to everyone, hope the week is progressing well.

> On Tue, November 10, 2009 1:39 am, Doug Ledford wrote:
> > On 11/06/2009 01:45 AM, Neil Brown wrote:
> >>
> >> Greetings.
> >>
> >>  About a week ago I released mdadm-3.1
> >>  I have now 'withdrawn' it meaning that it doesn't appear on the
> >>  kernel.org mirrors any more, and I ask people not to use it.
> >
> > Although the cause for this sucks, I was actually going to suggest that
> > since 3.1 is a version bump, that we take the opportunity to change a
> > few defaults.  Like switching to version 1 superblocks instead of
> > version 0 by default.  And changing the default chunk size to 512k
> > instead of 64k.  The time has simply come for the 0->1 superblock
> > change, and I have a good deal of data showing that for SATA disks at
> > least, the 512k chunk size is the typical sweet  spot.

> I had been toying with that idea myself - certainly of changing the
> defaults soon.  I'm tempted to make the default metadata "1.1"
> though possibly not for RAID1.  For RAID0,4,5,6,10 there is no value
> in having the metadata at the end of the device.  For RAID1 there is
> as it makes booting off any member easier.  Thoughts?

It may be heresy but I would suggest that if the defaults change we
should also implement support for auto-starting version 1.x devices,
or some appropriate subset of them.

I understand and appreciate the concerns of the userspace start
community.  However, we do a lot of storage on very dedicated systems
and I have spent far more time unsnarling systems with blown
initrd/initramfs setups and other boot issues than I have recovering
from starting RAID volumes on the wrong box.  Thats why I don't let
udev anywhere near production machines and I am still living on 0.9
metadata in spite of its limitations.

UNIX has always been about allowing people to shoot themselves in the
foot if they so desire.  I think an acceptable compromise would be to
move toward a default of disabled auto-detection with the option to
turn on detection of all meta-data types if people choose to do that.

> NeilBrown

Best wishes for a pleasant weekend to everyone.

}-- End of excerpt from "Neil F Brown"

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Join in the new game that's sweeping the country.  It's called
 `Bureaucracy`.  Everybody stands in a circle.  The first person to do
 anything loses."
                                -- Steve RTFM Przepiora
