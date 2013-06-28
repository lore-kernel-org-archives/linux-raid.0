From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: RAID1 growth of version 1.1/1.2 metadata violates least surprise.
Date: Fri, 28 Jun 2013 11:33:17 -0500
Message-ID: <201306281633.r5SGXHd9004034@wind.enjellic.com>
References: <neilb@suse.de>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: NeilBrown <neilb@suse.de>
       "Re: RAID1 growth of version 1.1/1.2 metadata violates least surprise." (Jun 24,  5:14pm)
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Jun 24,  5:14pm, NeilBrown wrote:
} Subject: Re: RAID1 growth of version 1.1/1.2 metadata violates least surpr

Hi, hope the week is going well for everyone.

> On Sun, 9 Jun 2013 09:33:05 -0500 "Dr. Greg Wettstein"
> <greg@wind.enjellic.com> wrote:
> 
> > Hi, hope the week is starting out well for everyone.
> >=20
> > We ran into an interesting issue secondary to the growth of a RAID1
> > volume with version 1.1 metadata.  We are interested in reflections
> > from Neil and/or others as to whether the problem can be addressed.
> >=20
> > We grew a RAID1 mirror which had its two individual legs provided by
> > SAN volumes from an SCST based target server.  We provisioned
> > additional storage on the targets and then updated the advertised size
> > of the two block devices.
> >=20
> > Following that we carried out a rescan of the block devices on the
> > initiator and then used mdadm to 'grow' the size of the RAID1 mirror.
> > That was about 4-5 months ago and we ended up running into issues when
> > the machine was just recently rebooted.
> >=20
> > The RAID1 mirror refused to assemble secondary to the superblocks on
> > the individual devices having a different idea of the volume size as
> > compared to the actual volume size.  The mdadm manpage makes reference
> > to this problem in the section on the '-U' (update) functionality.
> >=20
> > It would seem to violate the notion of 'least surprise' for a grow
> > command to work only to end up with a device which would not assemble
> > without external intervention at some distant time in the future.  It
> > isn't uncommon to have systems up for a year or more which tends to
> > result in this issue being overlooked on systems which have been
> > resized.
> >=20
> > I'm assuming there is no technical reason why the superblocks on the
> > individual devices cannot be updated as part of the grow.  Events such
> > as adding/removing persistent bitmaps suggest this is a possibility.
> > If its an issue of needing code we could investigate doing the
> > legwork since it is an issue we would like to see addressed.
> >=20
> > This behavior was experienced on a largely stock RHEL5 box with the
> > following versions:
> >=20
> > 	Kernel: 2.6.18-348.6.1.el5
> > 	mdadm:	v2.6.9
> >=20
> > Obviously running Oracle.... :-)
> >=20
> > Any thoughts/suggestions would be appreciated.
> >=20
> > Have a good week.

> (sorry for the delay - I guess I was having too much fun that week....)

I'm also currently completely funned out as well after picking up the
pieces from a creaky old RHEL kernel which corrupted a one terrabyte
filesystem since it couldn't seem to properly handle requests to abort
and retry some I/O..... :-)(

> Your description of events doesn't fit with my understanding of how
> things should work.  It would help a lot to include actual error
> messages and "mdadm --examine" details of devices.
>
> Certainly if you provision underlying devices to be larger and then
> "grow" the array, then the superblocks should be updated and
> everything should work after a reboot.
>
> If you were using 0.90 or 1.0 metadata which is at the end of the
> device there could be confusion when reprovisioning devices (that is
> mainly with --update=devicesize is for), but 1.1 metadata should
> not be affected.

I was able to initiate some additional testing and based on that setup
a simulation environment to test what is going on.  The problem seems
to be dependent on what kernel and version of mdadm one ends up
happening to intersect.

The take away for all the listeners at home is that growing a RAID1
array with 1.1 metadata on stock RHEL5, and I suspect there is a bunch
of it running out there, is probably not going to work without
stopping the array and then assembling it with --update=devicesize.
Once this is done a 'grow' command will work as advertised.

On the longterm 3.4.x kernel with mdadm 3.2.6 the following command:

	mdadm --grow /dev/mdN --size=max

Will update all the requisite super-blocks and initiate a
synchronization of the mirror up to the correct size.

On the longterm 3.4.x kernel with mdadm 2.6.9 (default version on
RHEL) assembling with --update=devicesize is also required.

This may be a problem which only people running storage fabrics will
run into.  I wanted to make sure we got this published since it may
save some headaches for others who find themselves in this
predicament.

If you are using a storage fabric to grow individual block devices in
a RAID1 setup you are also likely to be disinclined to take an outage
in order to get an array resized... :-)  One of the platforms we had
issues with had been up and running for almost three years.

One of the issues you may want to look at Neil, since it helped prompt
our note, was the documentation for --update=devicesize in the mdadm.8
man page.  Which as of 3.2.6 reads as follows:

	The devicesize option will rarely be  of  use. It
	applies to version 1.1 and 1.2 metadata only (where
	the metadata is at the start of the device) and  is
	only  useful  when the component device has changed
	size (typically  become  larger).   The  version  1
	metadata  records the amount of the device that can
	be used to store data, so if a device in a  version
	1.1  or 1.2 array becomes larger, the metadata will
	still be visible, but the extra space will not.  In
	this  case it might be useful to assemble the array
	with --update=devicesize.  This will cause mdadm to
	determine  the  maximum  usable  amount of space on
	each device and update the relevant  field  in  the
	metadata.

Which tended to reinforce our belief we were dealing with what seemed
to be anamolous behavior.  Given what we are seeing with old userspace
it may be a situation where the tooling grew the necessary
capabilities but the documentation didn't follow.

> So: I need details - sorry.
> 
> NeilBrown

Sorry for any misdirection Neil.  If you see this again the correct
response is 'upgrade mdadm'.

Hopefully having this documented may save you additional mail and the
user community some wasted time and frustration.

Have a good weekend.

}-- End of excerpt from NeilBrown

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Laugh now but you won't be laughing when we find you laying on the
 side of the road dead."
                                -- Betty Wettstein
                                   At the Lake

