From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 4*300GB SW-RAID5 - bad idea?
Date: Tue, 14 Oct 2003 09:51:48 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310140948410.29390@unicorn.drogon.net>
References: <200310140017.41042.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310140017.41042.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 14 Oct 2003, Hermann Himmelbauer wrote:

> Hi,
> I am considering putting up a slow but huge storage area. For cost reasons I
> am considering 4* 300GB Maxtor 5400 drives with Linux Software RAID5.
>
> The CPU of this machine would be a P4-2.4Ghz.
>
> Some people told me that this configuration would be a bad idea as accessing
> the RAID would produce a very high load and the RAID would be very slow.
>
> Is this true? Are there any performance/CPU Load stats with Linux SW-RAID that
> I can have a look at?

It'll be no slower than a single drive.

Do make sure you use additional controllers though - you'll want to have 4
disks set to master (I'm presuming these are IDE disks) So you'll need to
use the on-board controllers for 2 disks, and a separate dual channel PCI
controller for the other 2 disks.

I'm having bad experiences with the Promise controllers though, but from
what I gather they are the best of a bad bunch. (Promise Technology, Inc.
20269) They _seem_ to work, but sometimes miss an interrupt or something
and you get a process hanging in a "D" state for 10-30 seconds. On one
occasion I've had the raid software detect this as a missing disk and
knocked out that drive...

Gordon
