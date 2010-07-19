From: Neil Brown <neilb@suse.de>
Subject: Re: Changing Chunk Size on Array
Date: Tue, 20 Jul 2010 01:49:55 +0200
Message-ID: <20100720014955.529eb9ca@notabene>
References: <CC.8D.04655.49D124C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CC.8D.04655.49D124C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 17 Jul 2010 16:15:55 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> 
> 	I'm thinking about changing the chunk size on one of my arrays in
> order to potentially improve performance.  The man page rather suggests -c
> is a vlaid option under Grow mode, although it doesn't specifically say
> mdadm supports it under --grow.  Is it indeed supported under mdadm 2.6.7.2
> and kernel 2.6.26-2?  Assuming so, I would like to know a bit more about the
> change before issuing the command.  Speficialy, what are the details of the
> process?  Does the entire (RAID 6) array have to be re-written, such as is
> the case with adding a drive to the array?  Does the recovery start
> immediately?  Can it be interrupted and then continue at a later time?

Yes, you can change chunksize with --grow.
I think you need mdadm-3.1.2 and kernel 2.6.32 though (version numbers might
not be accurate, but are close).

Yes, the entire array gets re-written just like adding an extra device.
The reshape does start immediately.
If you shutdown or crash, then on restart the reshape will pick up where it
left off.

NeilBrown

