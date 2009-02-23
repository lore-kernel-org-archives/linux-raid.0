From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Reliability of bitmapped resync
Date: Mon, 23 Feb 2009 22:40:16 +0100
Message-ID: <20090223214016.GB18555@lazy.lzy>
References: <20090223194019.GA3488@lazy.lzy> <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name> <20090223201905.GA7585@lazy.lzy> <e3d195aab8b8de113e146e2932996777.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e3d195aab8b8de113e146e2932996777.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> I might have found something.  If the bitmap chunk size is smaller than
> the raid10 chunk size, and the first bitmap chunk in a raid10 chunk is
> clean, it might be skipping the remaining bitmap chunks in that
> raid10 chunk.

the RAID-10 chunk is standard 64K, the bitmap
chunk should be 256K.
So, this does not seem to be the case, if I
got it correctly.

> Can you please show me "--examine" and "--examine-bitmap" of one of the
> devices in your array please.

OK, but you'll have to wait until tomorrow, I do
not have the PC here (it is an office PC).

bye,

-- 

piergiorgio
