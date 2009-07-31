From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: help with bad performing raid6
Date: Fri, 31 Jul 2009 20:21:18 +0200
Message-ID: <20090731182118.GB11756@rap.rap.dk>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com> <72dbd3150907301409t5ea20979gcf400e4c53a32d62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <72dbd3150907301409t5ea20979gcf400e4c53a32d62@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Jon Nelson <jnelson-suse@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 30, 2009 at 02:09:19PM -0700, David Rees wrote:
> On Mon, Jul 27, 2009 at 12:19 PM, Jon Nelson<jnelson-suse@jamponi.net> wrote:
> > When I say "bad performance" I mean writes that vary down to 100KB/s
> > or less, as reported by rsync. The "average" end-to-end speed for
> > writing large (500MB to 5GB) files hovers around 3-4MB/s. This is over
> > 100 MBit.
> 
> That doesn't sound too unexpected.  rsync does a lot of reading and
> writing, so you're going to see less than network speeds.

rsync also does a lot of computing, so that is also a source of delay.
For faster cpu's the delay is not so big. I get near network speed ( 80
Mbit/s on a 100 Mbit/s LAN) between two of my faster machines.


best regards
keld
