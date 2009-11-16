From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 3.0.3 bug report
Date: Mon, 16 Nov 2009 13:39:52 +1100
Message-ID: <19200.47992.724204.514237@notabene.brown>
References: <cccedfc60911090743m77b26b7bx98bf5d18b7e96311@mail.gmail.com>
	<e9c3a7c20911091647r4efae6ear9938cb3388775abe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Monday November 9
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday November 9, dan.j.williams@intel.com wrote:
> On Mon, Nov 9, 2009 at 8:43 AM, Jon Nelson
> <jnelson-linux-raid@jamponi.net> wrote:
> > I tried to create a raid thusly:
> > mdadm --create /dev/md3 --level=10 --layout=f2 --metadata=ddf
> > --raid-devices=2 --assume-clean /dev/sdc1 missing
> > and while I got a non-zero exit code (1), I did not get an error
> > message or any other indication of failure.
> >
> > The misfeature is that I expected some sort of message.

Thanks for the report.  mdadm-3.1.1 will be more verbose.

In that particular case:

mdadm: DDF does not support level 10 arrays

If you try the same with --level=5

mdadm: ddf: Cannot create this array on device /dev/sdc1 - a container is required.


> 
> Yes, there should be a message that points out that the external
> metadata formats ('ddf' and 'imsm') require a container to be created
> first and then raid volumes are carved out of that container.  The
> mdmon man page has a little blurb on containers.  The 'missing' option
> is currently not supported for creating containers so you would need
> to modify this to something like:

I really should do something about supporting the 'missing' option,
and in general being able to specify which devices in the container
should be used....

> 
> mdadm --create /dev/md/ddf -e ddf /dev/sdc /dev/sdX -n 2
> mdadm --create /dev/md/volume0 /dev/md/ddf --level=10 --layout=f2

Except that ddf doesn't know "RAID10", it knows "RAID1E" with layouts
of "ADJACENT" (like n2) or OFFSET (like o20).
But mdadm/ddf doesn't handle RAID1E yet - I guess it should.

NeilBrown
