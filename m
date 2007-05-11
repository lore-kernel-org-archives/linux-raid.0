From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: removed disk && md-device
Date: Fri, 11 May 2007 12:51:40 +0400
Message-ID: <46442E9C.3050603@msgid.tls.msk.ru>
References: <200705091417.09033.bs@q-leap.de>	<20070509131450.GA31985@lapse.madduck.net>	<200705091539.53863.bs@q-leap.de>	<17986.50678.340484.891578@notabene.brown>	<46432D4B.4010302@dgreaves.com> <17987.51381.756955.577977@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17987.51381.756955.577977@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Greaves <david@dgreaves.com>, Bernd Schubert <bs@q-leap.de>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, 416512@bugs.debian.org
List-Id: linux-raid.ids

Neil Brown wrote:
[]
>> But joggling a usb stick (similar to your use case) would probably be OK since
>> it would be hot-removed and then hot-added.
> 
> This still needs user-space interaction.
> If the USB layer detects a removal and a re-insert, sdb may well come
> back a something different (sdp?) - though I'm not completely familiar
> with how USB storage works.

This is in fact an.. interesting issue.

Suppose I pulled the USB cable of sdb -- the WRONG one -- by a mistake.
I noticed this immediately (since the led on the disk stopped lighting),
and plugged the cable back again.  There was no write requests to the
array during this time, there was no ANY requests to it at all, it was
completely idle.

But.

The unplug immediately triggers USB device removal.  But md subsystem still
holds a reference to (now orphan) sdb.  So upon plugging it back, since
sdb is busy, scsi subsystem (which handles USB disks) grabs first available
sdX device, let's say it'll be sdp.

So we've orphan sdb which is "in use" by the array, and fresh new sdp,
which is unused but contains the orphaned array component.

And there's no way to hot-re-add sdp to the array (there's nothing to do
to the array itself!) but.. to powercycle the machine!  Because on
hot-remove, event count will be updated on the still-plugged-in device
(sda let it be), and upon hot-add, md will start resyncing.  Oh well...
(the only help from md subsystem here is in case if it is using bitmaps,
but that's different issue.)

> In any case, it should really be a user-space decision what happens
> then.  A hot re-add may well be appropriate, but I wouldn't want to
> have the kernel make that decision.

The question now isn't about decision anymore.  The question is now
about a possibility to implement that decision.

/mjt
