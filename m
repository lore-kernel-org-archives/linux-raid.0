From: hansbkk@gmail.com
Subject: Re: high throughput storage server?
Date: Tue, 15 Feb 2011 12:49:51 +0700
Message-ID: <AANLkTimwd8YdWBeKyVb4Sq+W-we5ura79ZyLL=1ufro9@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
	<20110215044434.GA9186@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215044434.GA9186@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Doug Dumitru <doug@easyco.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I highly recommend taking a look at Openfiler, pretty simple to set up
and very flexible, really just a stabilized/tested "appliance" built
on Linux/FOSS tools. Then your choices come down to what
top-of-the-line hardware you'd like to buy. . .

With the money you'd save from not going COTS, you could build two of
them and create high-availability mirrored servers with DRBD/heartbeat
for extra redundancy/fault-tolerance. And pre-pay for a full lifetime
of support, if that gives you and the company an extra level of
comfort. And still have a nice chunk of budget left over for UPSs,
backup hardware, network capacity expansion etc.
