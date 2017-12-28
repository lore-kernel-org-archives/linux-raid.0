From: Phil Turmel <philip@turmel.org>
Subject: Re: 3-way mirror to RAID-6
Date: Thu, 28 Dec 2017 07:34:00 -0500
Message-ID: <1f497643-0ad1-5037-207a-9c999dc79ccd@turmel.org>
References: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
 <87incu79uw.fsf@notabene.neil.brown.name>
 <CAJH6TXh_u08K+w-na_YQDh0WZWOQ8o14=SEzQmwPVrGPbkWasA@mail.gmail.com>
 <063586b9-6b63-9afe-9edc-dd3a73adf1b4@turmel.org>
 <CAJH6TXiqsd=Zs4t5qAEe19shJFgSAZ1W-95yT041H6OyLbKvfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXiqsd=Zs4t5qAEe19shJFgSAZ1W-95yT041H6OyLbKvfA@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: NeilBrown <neilb@suse.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/28/2017 03:33 AM, Gandalf Corvotempesta wrote:
> Il mercoledì 27 dicembre 2017, Phil Turmel <philip@turmel.org
> <mailto:philip@turmel.org>> ha scritto:
> 
>     I think you mean "is an issue" ....
> 
> 
> No, is not an issue as long it's a temporary step...

Ok.  Then:

> I can remove one disk from the 3way mirror for this operation, after
> that, growing from a 2way mirror to a raid6 should be possible, right ?

Yes, I think so.  A quick test with some loop devices on your kernel
will tell you for sure, and if it will take only one step.

> Yes I have LVM and I can add a fifth drive, but I prefer to only add a
> fourth drive and move from current 3way mirror to raid 6

With LVM, it is always possible to set up new drives in an entirely new
raid of the desired configuration, possibly with a "missing" or two, add
it as a physical volume to the same VG, then mirror the LVs across both
arrays.  (Or just pvmove if the target array's redundancy is
sufficient.)  Move redundant drives from old array to new if needed,
then vgreduce to drop the old array.

> It's a mailserver, is a raid6 a performance killer? 

I've never put a mail archive on raid6.  I'd be concerned.  It's
basically a random access workload with small reads and writes.  That is
a recipe that'll maximize the write-amplification slowdown of raid6.

Consider converting to raid10,near3 n=4, or raid10,near3 n=5 to get a
little more capacity but keep the high performance of mirroring.  Raid10
doesn't require the array's member count be a multiple of the number of
copies.

Phil
