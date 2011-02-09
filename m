From: Chris Worley <worleys@gmail.com>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 08:45:29 -0700
Message-ID: <AANLkTinCccc_qY5e=AfPsfkMnfH+Vpk2q+dm0WMxt2xu@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<20110209090522.GA8632@bounceswoosh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209090522.GA8632@bounceswoosh.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, maurice <mhilarius@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 9, 2011 at 2:05 AM, Eric D. Mudama
<edmudama@bounceswoosh.org> wrote:
<snip>
> I agree that in aggregate we've now done 2 units worth of writes,
> however, in a mirror case, we're protecting against both whole-device
> failure and single-sector failure modes, so hardly seems like a bad
> idea in all applications.

Yes, just pass through the discards, and let us mirror.  Sync'ing a
new drive w/o writing (only what needs to be written) is really
trivial (needs no extra saved metadata/LBA bitmaps or ability to query
the device for active sectors), if folks would give it some thought
and quit saying it shouldn't be done.
