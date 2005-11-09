From: Konstantin Olchanski <olchansk@sam.triumf.ca>
Subject: Re: udev and mdadm -- I'm lost
Date: Tue, 8 Nov 2005 23:57:32 -0800
Message-ID: <20051109075732.GB7815@sam.triumf.ca>
References: <1b9.203c2461.30a28d17@aol.com> <43713767.1060602@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43713767.1060602@mvista.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Jiang <djiang@mvista.com>
Cc: AndyLiebman@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 08, 2005 at 04:40:23PM -0700, Dave Jiang wrote:
> >I see there is an mdadm  --auto option now...
> 
> Just use --auto or --auto=yes and it should take care of the device node 
>  creations. I have a /etc/mdadm.conf so I just do:
> mdadm -As --auto=yes and it brings everything up over udev.

I face a similar problem each time I use KNOPPIX to revive a non-booting
server. It always takes me 10-20 minutes to figure out the right
mdadm incantation to start the md devices. It does not help that mdadm
wants an /etc/mdadm.conf which is on an md device itself, unaccessible.

I wish there were a simple command to find and start all md devices, something
along the lines of:

mdadm --please-find-and-start-all-my-md-devices-please-please-please
or
mdadm --start-all, or whatever.

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
