From: Keld =?utf-8?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Faster read performance DURING (?) resync on raid10
Date: Thu, 25 Sep 2008 20:40:40 +0200
Message-ID: <20080925184040.GA8608@rap.rap.dk>
References: <19666016.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19666016.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: sminded <daniel.zetterman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 25, 2008 at 02:27:51AM -0700, sminded wrote:
> 
> I have done some automated scripted tests with bonnie++ over RAID10 and
> encryption, using different encryption cipher modes to evaluate the impact
> on I/O operations.
> The strange thing is that I can see a significant increase in read
> performance (about 20%) when running the tests DURING the raid resync phase
> directly after the raid creation as appose to running it after the resync,
> or after I create the array with --assume-clean (which skips initial
> resync).
> 
> Have anyone noticed the same behaviour, and how can it be explained? Any
> ideas?
> 
> Can someone else verify that they get the same result?

I noticed something similar, vastly enhanced performance just after 
creation, but found out that some parameters needed to be changed,
setreadahead or some such.

What are the actual figures?

Best regards
Keld
