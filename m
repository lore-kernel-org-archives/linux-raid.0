From: Aryeh Leib Taurog <vim@aryehleib.com>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Wed, 7 Jan 2015 10:30:06 +0200
Message-ID: <20150107083006.GA4743@deb76.aryehleib.com>
References: <20150104210701.GG4713@deb76.aryehleib.com>
 <54A9B472.9090905@youngman.org.uk>
 <20150106075400.4a208293@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150106075400.4a208293@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 06, 2015 at 07:54:00AM +1300, NeilBrown wrote:
> The fault is detected by the drive, possibly using a CRC, or by the
> controller (hmm.. the drive isn't responding, must be faulty!) and this fault
> is communicated to md.  md then manages the fault by accesses the other
> device.

I imagine that RAID does introduce a risk here.  If the drive is fine 
and the other hardware isn't, one really could end up with disparate 
data.  I have had situations (perhaps related to the flaky cable I 
recently discovered) where I wrote "A" to the drive and then read back 
"B."  On a single drive system, it's possible to confirm a write by 
reading it, but with RAID that is not the case.  So RAID increases my 
safety against drive failure at the expense of increased reliance on 
the other hardware.  (Sorry if this is all obvious, I'm new to RAID 
and trying to get this clear for myself.)

My current procedure is to make a backup with dar, test the archive, 
and then generate par2 recovery files.  The par2 files give me some 
protection against data corruption, but that only helps if I can rely 
on the initial test.  So I guess my options are to use more reliable 
hardware and/or to backup first to a single drive, on which I test and 
generate recovery files, and then copy to RAID device.

> *No* RAID level has error detection ability - *all* RAID levels (except zero)
> have error correction - providing something else detects the error.
> Parity vs mirroring makes no difference here.
> 
> And to answer the original question: just let it resync.

Thank you all for your answers.

I still didn't get clear confirmation about what resync does, though.  
I understand that md doesn't have any way of knowing *which* drive is 
the "correct" drive, but it *has* decided somehow from which to 
assemble the array and which to ignore.  I am assuming that the 
procedure is to add it back with (the man page implies that -a would 
have the same effect in this case)

    mdadm /dev/md/backup --re-add /dev/sdc2

and that md will 'resync' i.e. make a byte-for-byte copy of the first 
device back onto the second device.  I thought this was obvious, but 
several objections were raised so I'm not entirely sure any more.  Is 
it any more or less than that?

I'm also not sure, given the objections about md not having psychic 
powers, how exactly md did decide which device to include and which to 
ignore, and I'm puzzled by this message:

    mdadm: ignoring /dev/sdc2 as it reports /dev/sdd2 as failed

The logic seems reversed to me.  Is this just the artifact of a 
possibly buggy version of md, or am I missing something here also?

> Had you started that when you asked the question it would be done by 
> now :-)

Of course, but the goal was to learn more about what I'm doing, not to 
save time.  I usually favor a deeper understanding over expedience.

> To avoid similar problems in future:
>  - use a newer mdadm (sorry, but there are bugs sometimes)
>  - add an internal write-intent bitmap.  That makes the resync much faster
>    when needed
>  - Possibly as '--no-degraded' when assembling arrays.

Thanks.  This is all quite helpful.
