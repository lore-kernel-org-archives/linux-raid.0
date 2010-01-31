From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Swapping a disk without degrading an array
Date: Sun, 31 Jan 2010 17:33:55 +0100
Message-ID: <20100131163355.GA25622@twister.home>
References: <1264421475.30742.49.camel@test.apertos.eu>
 <20100129221904.439e2afe@notabene>
 <87tyu4zzxo.fsf@frosties.localdomain>
 <4B65A2EB.1000506@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B65A2EB.1000506@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Sun, Jan 31, 2010 at 04:34:03PM +0100, Asdo wrote:

> 1/ The live-spare gets filled of data without recording anything on
> any superblocks. If there is a power failure and reboot, the new MD
> will know nothing about this. The process has to be restarted.

IMHO MD must know about the copy and it must know not to use the new
device before the copying is completed. Otherwise after a reboot mdadm
may either import the new half-written spare instead of the real one if
the superblock is already copied, or other tools like LVM may start
using the new half-written spare instead of the RAID if the MD
superblock is still missing.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
