From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: limits on raid
Date: Fri, 15 Jun 2007 22:03:20 -0400
Message-ID: <20070616020320.GB2002@animx.eu.org>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759392AbXFPCH0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18034.3676.477575.490448@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday June 14, david@lang.hm wrote:
> > why does it need to do a rebuild when makeing a new array? couldn't it 
> > just zero all the drives instead? (or better still just record most of the 
> > space as 'unused' and initialize it as it starts useing it?)
> 
> Yes, it could zero all the drives first.  But that would take the same
> length of time (unless p/q generation was very very slow), and you
> wouldn't be able to start writing data until it had finished.
> You can "dd" /dev/zero onto all drives and then create the array with
> --assume-clean if you want to.  You could even write a shell script to
> do it for you.

I still fail to see the reason to actually "resync" the drives.  I've dealt
with some hardware raid devices and they do not force a resync but they do
recommend it.

If there was no resync (I have not found a way to force the kernel not to do
this), the parity will not be correct.  Well in this case, that's fine, the
data is pretty much useless anyway.  (I'm assuming newly created arrays,
not attempting to recreate an array that had some failures)

Noone zeros out a new hard drive because of what might be on it.  You just
fdisk (or lvm or whatever), mkfs and use it.  Assume this is performed on an
array that has not been resync'd (or initialized as some hardware raids call
it).  You fdisk it, mkfs it, and start using it.  As I understand the way
raid works, when you write a block to the array, it will have to read all
the other blocks in the stripe and recalculate the parity and write it out.
(I also assume that if you write lots of data at a time, there may not be a
read since those sectors will be over written anyway).

Ok, so we have a device with some parity information "correct" due to writes
of some of the sectors but not all of them since there was no resync.  What
happens if a drive fails and you replace it?  Ok, now we have to resync. 
The strips that were never written to may now have random data.  Well, does
that *really* matter?  After all, it was never written to.

In the past, I have used arrays that were not initialized (hardware raids)
and had to rebuild the array due to a disk failure.  There was no problems
with the data that was already allocated on the array.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
