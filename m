From: Neil Brown <neilb@suse.de>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Fri, 7 Nov 2008 17:13:10 +1100
Message-ID: <18707.56438.952450.800570@notabene.brown>
References: <18692.62860.863118.727187@notabene.brown>
	<1225387127.26510.155.camel@firewall.xsintricity.com>
	<18698.54207.663716.200113@notabene.brown>
	<1225722871.26510.326.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday November 3
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Monday November 3, dledford@redhat.com wrote:
> 
> The in-kernel names are set by the kernel md code.  Right now, it has a
> simplistic test that checks if the device is partitionable, then sets
> the kobject name to either md%d or md_d%d.  The key point being that the
> md code gets to set the kobject name, and it's the kobject name that is
> used my udev.  Don't get me wrong, I know changing this setup now would
> break udev horribly, this being because udev current does
> subsystem==block,kernel=="md*" to match all md devices.  In order to
> break from this, we would need to do something like
> subsystem==block,subtype==md and skip any name check tests.  Then we
> could in fact use arbitrary names and udev and the rest of the system
> would be fine.  So, I'm not saying it would work today, but that doesn't
> mean it couldn't be designed for and then implemented with a coordinated
> change to the kernel and udev.

That's an interesting idea.

   echo md_fred > /sys/modules/md_mod/parameters/new_array
   # /sys/block/md_fred magically appears with some random minor number
   # udev ignores it because md/array_state is 'clear'
   cd /sys/block/md_fred/md
   echo raid5 > level
   .....
   echo active > array_state
   # udev gets a CHANGE event and creates /dev/md_fred, and/or
   #  /dev/md/fred plus any partitions that are found.

I think that we need to have the "md_" prefix.  I don't want someone
ever to be able to create and md array called "sda"!
And I think this would work with udev today, though mdadm wouldn't
make use of it, and could get confused if some other code did.

Any code which parses /proc/mdstat and expects to see "md%d" there
will also get confused.

But this is the first idea I have seen that really gives some value in
an alternate way for creating md arrays (alternate to just opening the
block-special device).

Thanks for the suggestion.

NeilBrown

 
