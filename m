From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] support for detecting platform raid capabilities and some fixes
Date: Tue, 2 Dec 2008 17:18:29 +1100
Message-ID: <18740.54069.607869.865438@notabene.brown>
References: <1227743100.31146.41.camel@dwillia2-linux.ch.intel.com>
	<18735.12218.461012.396198@notabene.brown>
	<e9c3a7c20811281116n5250b4bfv498c83de9710a414@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Friday November 28
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Friday November 28, dan.j.williams@intel.com wrote:
> On Thu, Nov 27, 2008 at 4:39 PM, Neil Brown <neilb@suse.de> wrote:
> > So what happens when you try to create an array on devices that aren't
> > attached to a detected platform?  Or create an array that crosses two
> > separate controllers?
> > Just a warning?  Require --force?  Do nothing ??
> >
> > Sounds like a useful thing!
> 
> Right now it just returns errors from ->validate_geometry and
> ->add_to_super.  The environment variable IMSM_NO_PLATFORM turns off
> this checking.  The --assemble case could take advantage of this as
> well to warn or fail to assemble when disks are found on "non-raid"
> ports, currently 'platform' checking is silent at assembly.  Different
> environments could have different policies...
> 
> Here is a lingering idea that may be post mdadm-3.0 material: What
> about exposing these policy decisions via a new configuration file
> variable: HBA?
> HBA device=<'platform' | sysfs device path | some other identification
> tuple> enforce_ports=<no | yes | warn> auto_hotplug=<no | yes>
> 
> Where enforce_ports checks for assembly or create events talking to
> HBA-attached disks and 'auto_hotplug' handles re-adding disks on a
> hotplug event where the administrator expects this to happen for the
> "raid controller" but not for example usb-storage.

I think were certainly want something like that.

> > And I notice that you hunt through all of the option-rom memory to
> > find the option from for the IMSM to read some details.
> > Once you have the I/O Controller, can you just look in the "resource"
> > file to get start/length info and read just that area ???
> 
> Scanning through option-rom memory was a bit unpalatable to me as
> well, and I expected to find this region mapped via an expansion-rom
> bar.  However this is not the case as there does not appear to be an
> associated 'resource' file with this range.  /proc/iomem reports:
> 000c0000-000dffff : pnp 00:01
> 
> /sys/bus/pnp/devices/00:01/ does not contain anything that would point
> me to the eventual 0xce840 in this case.

That's fairly boring.
Can we at least check that it is 'mem' space rather than 'io' space
that we are hunting through.
I can see in  /sys/bus/pnp/devices/*/resources  that some ranges are
'mem' and some are 'io'.
??


Thanks,
NeilBrown
