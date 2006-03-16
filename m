From: Nix <nix@esperi.org.uk>
Subject: Re: A random initramfs script
Date: Thu, 16 Mar 2006 07:39:27 +0000
Message-ID: <874q1yrg7k.fsf@hades.wkstn.nix>
References: <87u0a0so6w.fsf@hades.wkstn.nix>
	<20060315002527.GO27173@skl-net.de> <87lkvcrtzu.fsf@hades.wkstn.nix>
	<20060315185750.GP27173@skl-net.de>
	<17432.59463.266472.266509@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17432.59463.266472.266509@cse.unsw.edu.au> (Neil Brown's
 message of "Thu, 16 Mar 2006 15:23:35 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 Mar 2006, Neil Brown wrote:
> On Wednesday March 15, maan@systemlinux.org wrote:
>> On 08:29, Nix wrote:
>> > Yeah, that would work. Neil's very *emphatic* about hardwiring the UUIDs of
>> > your arrays, though I'll admit that given the existence of --examine --scan,
>> > I don't really see why. :)
>> 
>> He likes to compare the situation with /etc/fstab. Nobody complains
>> about having to edit /etc/fstab, so why keep people complaining about
>> having to edit /etc/mdadm.conf?
> 
> Indeed!  And if you plug in some devices off another machine for
> disaster recovery, you don't want another disaster because you
> assembled the wrong arrays.

Well, I can't have that go wrong because I assemble all of them :)

One thing I would like to know, though: I screwed up construction
of one of my arrays and forgot to give it a name, so every array
with a V1 superblock has a name *except one*.

Is there a way to change the name after array creation? (Another
overloading of --grow, perhaps?)

(I'm still quite new to md so rather queasy about `just trying'
things like this with active arrays containing critical data.
I suppose I should build a test array on a sparse loopback mount
or something...)

> I would like an md superblock to be able to contain some indication of
> the 'name' of the machine which is meant to host the array, so that
> once a machine knows its own name, it can automatically find and mount
> its own arrays,

... and of course you could request the mounting of some other machine's
arrays if you cart disks around between machines :)

Seems like a good idea.

-- 
`Come now, you should know that whenever you plan the duration of your
 unplanned downtime, you should add in padding for random management
 freakouts.'
