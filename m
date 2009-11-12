From: greg@enjellic.com
Subject: Re: mismatch_cnt again
Date: Thu, 12 Nov 2009 13:20:13 -0600
Message-ID: <200911121920.nACJKDew011818@wind.enjellic.com>
References: <eyal@eyal.emu.id.au>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
       "Re: mismatch_cnt again" (Nov 10,  9:03am)
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
Cc: neilb@suse.de
List-Id: linux-raid.ids

On Nov 10,  9:03am, Eyal Lebedinsky wrote:
} Subject: Re: mismatch_cnt again

Good day to everyone.

> Thanks everyone,

> I wish to narrow down the issue to my question Are there situations
> known to cause this without an actual hardware failure?
>
> Meaning, are there known *software* issues with this configuration
> 	2.6.30.5-43.fc11.x86_64, ext3, raid5, sata, Adaptec 1430SA
> that can lead to a mismatch?
>
> It is not root, not swap, has weekly smartd scans and weekly
> (different days) raid 'check's. Only report is a growing
> mismatch_cnt.
>
> I noted the raid1 as mentioned in the thread.

I have concerns there is a big ugly issue waiting to rear its head in
the Linux storage community.  Particularly after reading Martin's note
about pages not being pinned through the duration of an I/O.

Speaking directly to your concerns Eyal.  One of my staff members runs
recent Fedora on his desktop with software RAID1.  On a brand new box
shortly after installation he is noting large mismatch_cnt's on the
RAID pairs.

He posted about the issue a month or so ago to the linux-raid list.
He received no definitive responses other than some vague hand waving
that ext3 could cause this.  I believe he is running ext4 on the RAID1
volumes in question.

Interestingly enough a filesystem check comes up normal.  So there are
mismatches but they do not seem to be manifesting themselves.  It
would seem that others confirm this issue.

More to the point we manage geographically mirrored storage systems.
Linux initiators receive fiber-channel based block devices from two
separate mirrors.  The block devices are used as the basis for a RAID1
volume with persistent bitmaps.

In the data-centers we have SCST based Linux storage targets.  The
target 'disks' are LVM based logical volumes platformed on top of
software RAID5 volumes.

We are seeing, in some cases, large mismatch_cnts on the RAID1
initiators.  Check runs on each of the two RAID5 target volumes show
no mismatches.  So the mismatch is occuring at the RAID1 level and is
independent of what is happening at the physical storage level.

The filesystems on the RAID1 volumes are ext3 running under moderate
to heavy load.  Initiator kernels, in general, have been reasonably
new, 2.6.27.x and forward, with RHEL5 userspace.

I suspect there are one or more subtle factors which are making the
non-pinned pages more of an issue then what they appear to be at first
analysis.  Jens and company have been putzing with the I/O schedulers
and related issues.  One possible bit of hand waving is that all of
this may be somehow confounded by elevator induced latencies.

Our I/O latencies are longer due to the physical issues of shooting
I/O through a fair amount of glass and multi-trunked switch
architectures.  In addition we configure somewhat deeper queue depths
on the targets which may compound the problem.  But that doesn't
explain Eyal's and other's issues with this showing up on desktop
systems.

In any case I am convinced the problem is real and potentially
significant.  What seems to be perplexing is why it isn't showing up
as corrupted files and the like.  We are not hearing anything from the
user side which would suggest manifestation of the problem.

More troubling in my opinion is how widespread the problem might be
and how do we fix it?  Automatic repair is problematic as has been
discussed, particulary in the case of a two pair RAID1 volume.  I'm
also equally apprehensive about doing a casino roll with data by
blindly running a 'repair'.

The obvious alternative is to compare the mismatches and figure out
which block is correct.  Pragmatically a somewhat daunting task on
potentially thousands of mismatches on multi-hundred gigabyte
filesystems.  Much more so when one considers the qualitative
assessment issue and the need to do this off-line to avoid Heisenberg
issues.

> cheers Eyal

So I think the problem is real and one we need to respond to as a
community sooner rather than later.  I shudder at the thought of an
LWN or Slashdot article heralding the fact there might be silent
corruption on thousands of filesystems around the planet... :-)(

Neil/Martin what do you think?

I'm happy to hunt if we can do anything from our end.

Best wishes for a pleasant weekend to everyone.

Greg

}-- End of excerpt from Eyal Lebedinsky

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If I'd listened to customers, I'd have given them a faster horse."
                                -- Henry Ford
