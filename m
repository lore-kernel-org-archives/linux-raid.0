From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Changing Chunk Size on Array
Date: Wed, 21 Jul 2010 00:52:51 -0500
Message-ID: <9C.59.23536.52B864C4@cdptpa-omtalb.mail.rr.com>
References: <20100720014955.529eb9ca@notabene>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100720014955.529eb9ca@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > 	I'm thinking about changing the chunk size on one of my arrays in
> > order to potentially improve performance.  The man page rather suggests
> -c
> > is a vlaid option under Grow mode, although it doesn't specifically say
> > mdadm supports it under --grow.  Is it indeed supported under mdadm
> 2.6.7.2
> > and kernel 2.6.26-2?  Assuming so, I would like to know a bit more about
> the
> > change before issuing the command.  Speficialy, what are the details of
> the
> > process?  Does the entire (RAID 6) array have to be re-written, such as
> is
> > the case with adding a drive to the array?  Does the recovery start
> > immediately?  Can it be interrupted and then continue at a later time?
> 
> Yes, you can change chunksize with --grow.
> I think you need mdadm-3.1.2 and kernel 2.6.32 though (version numbers
> might
> not be accurate, but are close).

	Oh, well.  I'll have to upgrade that system one of these days, but
definitely not right now.  'Possibly soon after "Squeeze" goes gold, but
definitely not before.

> Yes, the entire array gets re-written just like adding an extra device.
> The reshape does start immediately.
> If you shutdown or crash, then on restart the reshape will pick up where
> it

	Thanks.

