From: Phil Turmel <philip@turmel.org>
Subject: Re: URE, link resets, user hostile defaults
Date: Tue, 28 Jun 2016 14:28:46 -0400
Message-ID: <5772C1DE.9000403@turmel.org>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de>
 <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Hannes Reinecke <hare@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/28/2016 01:33 PM, Chris Murphy wrote:

> Perhaps there's a better way to do this than change the default
> timeout in the kernel? Maybe what we need is an upstream udev rule
> that polls SCT ERC for each drive, and if it's
> disabled/unsupported/unknown then it sets a much higher command timer
> for that block device. And maybe it only does this on USB and SATA.
> For anything enterprise or NAS grade, they do report (at least to
> smartctl) SCT ERC in deciseconds. The most common value is 70
> deciseconds, so a 30 second command timer is OK. Maybe it could even
> be lower but that's a separate optimization conversation.

When Neil retired from maintainership, I mentioned that I would take a
stab at this.  You're right, just setting the kernel default timeout to
180 would be a regression.  If I recall correctly, there are network
services that would disconnect if storage stacks could delay that long
before replying, whether good or bad.

So a device discovery process that examines the drive's parameter pages
and makes an intelligent decision would be the way to go.  But as you
can see, I haven't dug into the ata & scsi layers to figure it out yet.
 It won't hurt my feelings if someone beats me to it.

Phil
