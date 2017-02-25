From: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Sat, 25 Feb 2017 17:00:58 -0500
Message-ID: <aee1f55b-cedf-15e9-5865-7fc0cdf9a188@turmel.org>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
 <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
 <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/25/2017 03:05 PM, Anthony Youngman wrote:

> Although I would have thought build mode was superb for doing
> backups without needing to stop using the system ... I haven't seen
> any documentation about things like breaking raid to do backups and
> all that sort of thing.
> 
> I need to investigate it, but I'd like to know how to suspend a
> mirror, back it up, and then resume. The databases I work with have
> an option that suspends all new writes, but flushes all current
> transactions to disk so the disk is consistent for backing up. So if
> you do that and back up the database you know your backup is
> consistent.
> 
> This is all a rather important usage of raid, actually, imho. It
> seems so obvious - create a temporary mirror, wait for the sync to
> complete, suspend i/o to get the disk consistent, then you can break
> the mirror and carry on. Terabytes :-) of data safely backed up in
> the space of seconds.

No. Don't go there.  There's already a technology out there that does
this correctly, called LVM snapshots.  And they let you resume normal
operations after a very brief hesitation, and the snapshot holds the
static image while you copy it off.

Phil
