From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recommendations needed for RAID5 recovery
Date: Mon, 27 Jun 2016 11:06:45 +0200
Message-ID: <20160627090645.GA3255@metamorpher.de>
References: <B1389BE8-B7B5-4AB4-BE12-1636D4B91BB5@seas.upenn.edu>
 <CAOS+5GGxVOWw1nEfEgpVcLY0+tHPVV3d48BzyRATjpApgvSkxg@mail.gmail.com>
 <22381.43040.31844.544728@quad.stoffel.home>
 <576E6E68.9070209@youngman.org.uk>
 <576EB5FD.1000309@turmel.org>
 <5770452F.8000109@youngman.org.uk>
 <5770549C.4060301@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5770549C.4060301@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, Peter Gebhard <pgeb@seas.upenn.edu>, Linux-RAID <linux-raid@vger.kernel.org>, Another Sillyname <anothersname@googlemail.com>, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On Sun, Jun 26, 2016 at 06:18:04PM -0400, Phil Turmel wrote:
> I don't know *any* scenario where dd is useful for raid recovery.

Basically you use dd to make a copy to play around with but 
with overlays (as described in the RAID wiki) you don't need 
those copies anymore. [as long as the device is intact]

There is conv=noerror,sync however I found recently that it 
actually produces corrupt copies (changes offsets), still not 
sure what the conv=noerror,sync is actually supposed to be for.

( http://superuser.com/a/1075837/195171 )

So you shouldn't use dd on bad disks...

I've had my fair share of issues with ddrescue as well, it likes 
to get stuck forever and not continue. --min-read-rate=<bytes> 
might help in such a case... (better to copy regions that still 
work quickly rather than spending hours on error correction ...).

ddrescue produces a log (or a map) that records bad regions, 
so if you somehow need a device that still produces read errors 
for those, it can probably be magicked with the device mapper...

Regards
Andreas Klauer
