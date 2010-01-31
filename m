From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Swapping a disk without degrading an array
Date: Sun, 31 Jan 2010 18:32:22 +0100
Message-ID: <87ockai3ix.fsf@frosties.localdomain>
References: <1264421475.30742.49.camel@test.apertos.eu>
	<20100129221904.439e2afe@notabene>
	<87tyu4zzxo.fsf@frosties.localdomain> <4B65A2EB.1000506@shiftmail.org>
	<20100131163355.GA25622@twister.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100131163355.GA25622@twister.home> (Gabor Gombas's message of
	"Sun, 31 Jan 2010 17:33:55 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Asdo <asdo@shiftmail.org>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Gabor Gombas <gombasg@sztaki.hu> writes:

> On Sun, Jan 31, 2010 at 04:34:03PM +0100, Asdo wrote:
>
>> 1/ The live-spare gets filled of data without recording anything on
>> any superblocks. If there is a power failure and reboot, the new MD
>> will know nothing about this. The process has to be restarted.
>
> IMHO MD must know about the copy and it must know not to use the new
> device before the copying is completed. Otherwise after a reboot mdadm
> may either import the new half-written spare instead of the real one if
> the superblock is already copied, or other tools like LVM may start
> using the new half-written spare instead of the RAID if the MD
> superblock is still missing.
>
> Gabor

No that is exactly what he means to avoid.

His suggestion is that at the start the metadata area of the life-spare
is kept as is, being a simple unused spare. Only the in-memory data
records that it actualy is a live-spare and only the data part of the
device is mirrored.

Then at the end you remove the old disk, add the live-spare and record
the change in the metadata of all drives in an semi atomic way. If
anything interrupts the operation before this the live-spare will still
be recorgnised as normal spare when the raid is reassembled.

MfG
        Goswin
