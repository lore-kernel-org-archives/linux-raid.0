From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Sun, 28 Feb 2010 12:50:31 +0100
Message-ID: <4B8A5887.4080102@stud.tu-ilmenau.de>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at> <4B855987.1010605@xunil.at> <4B855B8C.8080802@xunil.at> <4B862F2C.5030302@texsoft.it> <4B86A943.3040804@anonymous.org.uk>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B86A943.3040804@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi John,

John Robinson schrieb:
> On 25/02/2010 08:05, Giovanni Tessore wrote:
> [...]
>> I see this is the 4th time in a month that poeple reports problem on
>> raid5 due to the read errors during reconstruction; it looks like the
>> 'corrected read errors' policy is quite a real concern.
> 
> If you mean md's policy of reconstructing from the other discs and
> rewriting when there's a read error from one disc of an array, rather
> than immediately kicking the disc that had a read error, I think you're
> wrong - I think md is saving lots of users from hitting problems, by
> keeping their arrays up and running, and giving their discs a chance to
> remap bad sectors, instead of forcing the user to do full-disc
> reconstructions more often which will make them more likely to hit read
> errors during recovery.

I think you misunderstood me.  I recently was told what you wrote in the
last paragraph.  I know it is good, as that is the most intelligently
possible behaviour of md.
BUT: if the drive takes let's say 2 min for internal error recovery to
succeed of fail (whichever, doesn't matter), then the SG EH layer of the
kernel will drop the disk, not md.  This forces md to drop the disk,
also.  The conclusion is: a technology is needed to prevent another
kernel level from dropping the disk.  This technology exists, it's
called SCT-ERC (Smart Control Transport - Error Recovery Control).  It's
the same as WD's TLER or Samsung's CCTL.  But it is non-volatile.  After
a power on reset the timeout-values are reset to factory defaults.  So
it needs to be set right before adding a disk to an array.
(for more info: check www.t13.org, find the ATA8-ACS documents)
> 
> I do think we urgently need the hot reconstruction/recovery feature, so
> failing drives can be recovered to fresh drives with two sources of
> data, i.e. both the failing drive and the remaining drives in the array,
> giving us two chances of recovering every sector.

I do not think this is easily possible.  One would have to keep a map
about the "in sync" sectors of an array member and the "failed" sectors.
 My guess is: this would need a partial redesign (again a new superblock
type containing information about "failed segments" probably).
Please correct me if I'm wrong and that is already included in 1.X (I'm
mostly working on 0.90 Superblocks).
> 
> Cheers,
> 
> John.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers,
Stefan.
