From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 13:25:05 +0100
Message-ID: <20090119122505.GB23623@rap.rap.dk>
References: <18763.7881.300921.177207@notabene.brown> <20081230191250.70701c5c@absurd> <18803.53032.383350.741460@nbeee.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18803.53032.383350.741460@nbeee.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would like to see some enhancements to  the raid code:

1. removal of need to set the readahead to say 32 MiB for certain 
   raid types to get the desired performance

2. getting resync and other performance up for raid10, possibly
   using bigger buffers.

3. growing raid10.

I wonder where this is placed in the roadmap. Neil?

best regards
keld
