From: Neil Brown <neilb@suse.de>
Subject: Re: Faster read performance DURING (?) resync on raid10
Date: Fri, 26 Sep 2008 14:18:19 +1000
Message-ID: <18652.25227.7530.435789@notabene.brown>
References: <19666016.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from sminded on Thursday September 25
Sender: linux-raid-owner@vger.kernel.org
To: sminded <daniel.zetterman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 25, daniel.zetterman@gmail.com wrote:
> 
> I have done some automated scripted tests with bonnie++ over RAID10 and
> encryption, using different encryption cipher modes to evaluate the impact
> on I/O operations.
> The strange thing is that I can see a significant increase in read
> performance (about 20%) when running the tests DURING the raid resync phase
> directly after the raid creation as appose to running it after the resync,
> or after I create the array with --assume-clean (which skips initial
> resync).

Sounds like the read-balancing is doing exactly the wrong thing -
quite possible.

What layout are you using (near, far, offset?), how many devices?

NeilBrown
