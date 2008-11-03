From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 3 Nov 2008 12:58:40 +0100
Message-ID: <20081103115840.GB16309@boogie.lpds.sztaki.hu>
References: <18692.62860.863118.727187@notabene.brown> <1225387127.26510.155.camel@firewall.xsintricity.com> <18698.54207.663716.200113@notabene.brown> <20081103092920.GA8902@boogie.lpds.sztaki.hu> <ac3eb2510811030233t55bd3655k2b71be68dda99735@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac3eb2510811030233t55bd3655k2b71be68dda99735@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Neil Brown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Mon, Nov 03, 2008 at 11:33:36AM +0100, Kay Sievers wrote:

> Network devices have only one entry point, if you insist you can think
> of the index number as another value, but there is always only one
> single name that matters.

And you have only one (major, minor) pair for block devices. No
difference.

> And we need to rename them because we have
> no real concept  of symlinks for network interfaces.
> 
> That is not true at all for block devices, you can identify them in
> many ways, by name, by physical location, by hardware ID from the
> stuff behind the devices, by filesystem metadata, by properies of the
> specific subsystem,

And you can identify network devices by name, physical location,
hardware address, stuff behind the devices (aka. network
autoconfiguration). Again no difference.


> ... Renaming block devices just does not make much
> sense, because there is no primary name to use, it all depends on the
> actual setup and personal preference.

Exactly. And that's why _I_ want to choose the name. The current
udev-based partial solution is not good enough, as even if I give a
meaningful name to a node in /dev the kernel still only tells me "there
is a bad sector on /dev/sdk" and I have to spend precious time to figure
out which device /dev/sdk is. OTOH if I could rename sdk to eg.
self1slot3 then the error message would contain _all_ the information I
need.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences,
     Laboratory of Parallel and Distributed Systems
     Address   : H-1132 Budapest Victor Hugo u. 18-22. Hungary
     Phone/Fax : +36 1 329-78-64 (secretary)
     W3        : http://www.lpds.sztaki.hu
     ---------------------------------------------------------
