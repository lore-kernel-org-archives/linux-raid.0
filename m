From: David Brown <david.brown@hesbynett.no>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 09:37:33 +0200
Message-ID: <591171BD.3060707@hesbynett.no>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>        <590B3039.3060000@youngman.org.uk>        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h90v8kt3.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Wols Lists <antlists@youngman.org.uk>
Cc: "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/05/17 16:50, Nix wrote:

> 
> I wonder... scrubbing is not very useful with md, particularly with RAID
> 6, because it does no writes unless something mismatches, and on failure
> there is no attempt to determine which of the N disks is bad and rewrite
> its contents from the other devices (nor, as I understand it, does it
> clearly say which drive gave the error, so even failing it out and
> resyncing it is hard).
> 

Please read Neil Brown's article on this: "Smart or simple RAID
recovery?" <http://neil.brown.name/blog/20100211050355>

> If there was a way to get md to *rewrite* everything during scrub,
> rather than just checking, this might help (in addition to letting the
> drive refresh the magnetization of absolutely everything). "repair" mode
> appears to do no writes until an error is found, whereupon (on RAID 6)
> it proceeds to make a "repair" that is more likely than not to overwrite
> good data with bad. Optionally writing what's already there on non-error
> seems like it might be a worthwhile (and fairly simple) change.
> 

Scrubbing /does/ rewrite disk blocks - when necessary.  It does not do
it explicitly, but the disks handle this themselves.

To the processor, a disk block is 4K of data.  But to the disk and its
controllers, it is 4K plus a sizeable amount of error checking and
correcting bits.  Some are spread out within the block, some are
collected together at the end of the block.  The ECC system can handle a
large number of failed bits, either in lumps caused by a physical defect
on the disk surface, or spread out due to the slow decay of the magnetic
orientation, or hits by cosmic rays.

When the disk is asked to read a block, it pulls up the data and the ECC
bits, and uses this to check and re-construct the 4K of data, and a
measure of how many errors were corrected.  On modern high-capacity
drives, it is normal that some errors are corrected on a read.  But if
more than a certain level occur, then the firmware will trigger a
re-write automatically to the same sector.  This will then be re-read.
If the error rate is low, fine.  If it is high, then the sector will be
remapped by the disk.

So simply /reading/ the data, as far as the processor is concerned, will
cause re-writes as and when needed.

