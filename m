From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be
 written?
Date: Sat, 5 Jan 2013 08:44:07 +0100
Message-ID: <20130105074406.GB16375@hellgate>
References: <20130104175458.GA3298@hellgate>
 <50E75CE2.8060105@hardwarefreak.com>
 <20130104234113.GA14799@hellgate>
 <50E777DC.1060804@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50E777DC.1060804@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 04, 2013 at 06:46:20PM -0600, Stan Hoeppner wrote:

> >> 1.  What filesystem are you using?
> > 
> > The filesystem is the "application": it's zfsonlinux. I'm putting it on
> > RAID10 instead of using the disks natively because I want to encrypt it
> > using LUKS, and encrypting each disk separately seemed wasteful of CPU (I
> > only have 3 cores).
> 
> I just love when the other shoe drops and it turns out to be a size 13
> boot... filled with lead.
> 
> Any reason why you intentionally omitted these critical details from
> your initial post?

Yes: I thought I was asking a theoretical question, not for advice on tuning
my specific setup, and thought - apparently correctly, I might add :) - that
including these details would only get everyone sidetracked into trying to
optimise for a specific application. I don't have a specific application
with a specific access pattern because I have to run all sorts of
applications on this box, on top of this array, simultaneously.

But meanwhile I think I have received an answer: the fact that zfs uses
blocks of 128k or less does not automatically mean that write performance
would suffer on a 512k-chunk RAID10 array because the Linux RAID10
implementation, very sensibly, doesn't insist on writes being aligned to
chunk boundaries.

So thanks.

-- 
                     Andras Korn <korn at elan.rulez.org>
         Reality is merely an illusion, albeit a very persistent one.
