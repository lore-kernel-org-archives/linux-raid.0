From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID header in XFS area?
Date: Mon, 6 Nov 2017 16:31:40 -0500
Message-ID: <658161d3-8229-9df8-5f37-bbb807040847@turmel.org>
References: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
 <59FE0739.8020400@youngman.org.uk>
 <63581b55-f7bc-4408-aa72-a8a5c7cc37bf@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63581b55-f7bc-4408-aa72-a8a5c7cc37bf@thelounge.net>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Wols Lists <antlists@youngman.org.uk>, "David F." <df7729@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/04/2017 02:34 PM, Reindl Harald wrote:
> Am 04.11.2017 um 19:30 schrieb Wols Lists:

>> What's happened is that mdadm has assembled the array, realised a 
>> disk is missing, AND STOPPED.
> 
> why would it be supposed that a simple mirror with a mising disk is 
> stopped while the whole point of mirroring is to not care about one 
> of the disks dying?

When a member device dies or is kicked out while running, the remaining
devices' superblocks are updated with that status.  (Can't update the
superblock on the one that died cause it's, you know, dead.)

If the system is rebooted at this point, mdadm can see on the
still-running drive that the missing drive is known to be failed and
will happily start up.

If for some reason the *other* drive wakes up and works on reboot, and
only that drive is working, mdadm sees that a drive is missing for an
unknown reason and stops.  This is to avoid the disaster known as "split
brain".

Split brain cannot be distinguished from the situation where a
previously non-degraded array is missing device(s) at startup, so mdadm
stops. Administrator input is needed to safely proceed.

Phil
