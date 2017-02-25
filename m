From: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Sat, 25 Feb 2017 18:41:36 -0500
Message-ID: <5172e2ab-e193-477b-52c4-86fbab0d52fe@turmel.org>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
 <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
 <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
 <aee1f55b-cedf-15e9-5865-7fc0cdf9a188@turmel.org>
 <58B2137B.6070608@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58B2137B.6070608@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/25/2017 06:30 PM, Wols Lists wrote:
> On 25/02/17 22:00, Phil Turmel wrote:

>> No. Don't go there.  There's already a technology out there that does
>> this correctly, called LVM snapshots.  And they let you resume normal
>> operations after a very brief hesitation, and the snapshot holds the
>> static image while you copy it off.
> 
> Will it let you put that snapshot on a hot-plug disk you can remove? For
> my little system I'd quite happily mirror it off onto a hard-disk and
> unplug it.

You can copy it off to any block device you like, or dd it to a file, or
dd and gzip to a compressed file.  Anything you can do to copy a
partition to backup can be used on the snapshot.

> Oh - and I'm not running lvm. Not that I think there's anything wrong
> with that, it's just yet another layer that I'm not (currently)
> comfortable with.

So you know how to use a hammer, and don't feel comfortable with using a
handsaw, so you're going to smash a board in two instead of sawing it?

Ok, maybe that was too facetious. (-:

> Is there a sound technical reason not to go there, or is it simply a
> case of "learn another tool for that job"? The less tools I have to know
> the better, imho.

Um, no, imnsho.  Learn new tools when you need them.

Linux raid has no formal mechanism to cleanly separate a mirror from a
running array, access it as a backup, and not risk corruption when
re-attaching it to the array.  Most filesystems write to the partition
when mounting, even for read-only mounts.  You cannot safely access the
disconnected member except via pure block reads.

Phil
