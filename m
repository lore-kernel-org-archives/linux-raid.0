From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: URE, link resets, user hostile defaults
Date: Tue, 28 Jun 2016 21:46:08 +0100
Message-ID: <5772E210.4090007@youngman.org.uk>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de>
 <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
 <5772C1DE.9000403@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5772C1DE.9000403@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Chris Murphy <lists@colorremedies.com>, Hannes Reinecke <hare@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/06/16 19:28, Phil Turmel wrote:
> On 06/28/2016 01:33 PM, Chris Murphy wrote:
> 
>> > Perhaps there's a better way to do this than change the default
>> > timeout in the kernel? Maybe what we need is an upstream udev rule
>> > that polls SCT ERC for each drive, and if it's
>> > disabled/unsupported/unknown then it sets a much higher command timer
>> > for that block device. And maybe it only does this on USB and SATA.
>> > For anything enterprise or NAS grade, they do report (at least to
>> > smartctl) SCT ERC in deciseconds. The most common value is 70
>> > deciseconds, so a 30 second command timer is OK. Maybe it could even
>> > be lower but that's a separate optimization conversation.
> When Neil retired from maintainership, I mentioned that I would take a
> stab at this.  You're right, just setting the kernel default timeout to
> 180 would be a regression.  If I recall correctly, there are network
> services that would disconnect if storage stacks could delay that long
> before replying, whether good or bad.
> 
> So a device discovery process that examines the drive's parameter pages
> and makes an intelligent decision would be the way to go.  But as you
> can see, I haven't dug into the ata & scsi layers to figure it out yet.
>  It won't hurt my feelings if someone beats me to it.

Talking off the top of my head :-) would it be possible to spawn a
kernel thread - if it takes longer than an aggressive time-out - that
just waits for far longer then rewrites it if the read finally completes?

In other words, wait for say the 70 deciseconds, then spawn the rewrite
thread, then continue waiting until whatever timeout. The thread could
actually not even time out but just wait for the drive to time out. If
the drive (eventually) responds rather than timing out then the rewrite
would hopefully fix the potential impending URE.

So we'd need two timeouts really. Timeout 1 says "if it takes longer
than this, do a background rewrite when it finally succeeds", and
timeout 2 says "if it takes longer than this, return an error, but let
the rewrite thread continue to wait".

Cheers,
Wol
