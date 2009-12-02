From: greg@enjellic.com
Subject: Re: /etc/cron.weekly/99-raid-check
Date: Wed, 2 Dec 2009 09:38:42 -0600
Message-ID: <200912021538.nB2FcgM8003851@wind.enjellic.com>
References: <lfarkas@lfarkas.org>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: Farkas Levente <lfarkas@lfarkas.org>
       "/etc/cron.weekly/99-raid-check" (Nov 30,  2:08pm)
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@lfarkas.org>, CentOS mailing list <centos@centos.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Nov 30,  2:08pm, Farkas Levente wrote:
} Subject: /etc/cron.weekly/99-raid-check

> hi,

Hi Farkas, hope your day is going well.  Just thought I would respond
for the edification of others who are troubled by this issue.

> it's been a few weeks since rhel/centos 5.4 released and there were many
> discussion about this new "feature" the weekly raid partition check.
> we've got a lot's of server with raid1 system and i already try to
> configure them not to send these messages, but i'm not able ie. i
> already add to the SKIP_DEVS all of my swap partitions (since i read it
> on linux-kernel list that there can be mismatch_cnt even though i still
> not understand why?). but even the data partitions (ie. all of my
> servers all raid1 partitions) produce this error (ie. ther mismatch_cnt
> is never 0 at the weekend). and this cause all of my raid1 partitions
> are rebuild during the weekend. and i don't like it:-(
> so my questions:
> - is it a real bug in the raid1 system?
> - is it a real bug in my disk which runs raid (not really believe since
> it's dozens of servers)?
> - the /etc/cron.weekly/99-raid-check is wrong in rhel/centos-5.4?
> or what's the problem?
> can someone enlighten me?

Its a combination of what I would consider a misfeature with what MAY
BE, and I stress MAY be a sentient bug someplace.

The current RAID/IO stack does not 'pin' pages which are destined to
be written out to disk.  As a result the contents of the pages may
change as the request to do I/O against these pages transits the I/O
stack down to disk.

This results in a 'race' condition where one side of a RAID1 mirror
gets one version ofdata written to it while the other side of the
mirror gets a different piece of data written to it.  In the case of a
swap partition this appears to be harmless.  In the case of
filesystems there seems to be a general assurance that this occurs
only in uninhabited portions of the filesystem.

The 'check' feature of the MD system which the 99-raid-check uses
reads the underlying physical devices of a composite RAID device.  The
mismatch_cnt is elevated if the contents of mirrored sectors are not
identical.

The results of the intersection of all this are problematic now that
major distributions have included this raid-check feature.  There are
probably hundreds if not thousands of systems which are reporting what
may or may not be false positives with respect to data corruption.

The current RAID stack has an option to 'repair' a RAID set which has
mismatches.  Unfortunately there is no intelligence in this facility
and it randomly picks one of the sectors as being 'good' and uses that
to replace the contents of the other sector.  I'm somewhat reticent to
recommend the use of this facility given the issues at hand.

A complicating factor is that the kernel does not report the location
of where the mismatches occur.  There appears to be movement underway
to include support in the kernel for printing out the sector locations
of the mismatches.

When that feature becomes available there will be a need to have some
type of tool, in the case of RAID1 devices backing filesystems, to
make an assessment of which version of the data is 'correct' so the
faulty version can be over-written with the correct version.

	As an aside what is really needed is a tool which assesses
	whether or not the mismatched sectors are actually in an
	inhabited portion of the filesystem.  If not the 'repair'
	facility on RAID1 could be presumably run with no issues.
	Given the appropriate coherency/validation checks to make sure
	the sectors are still incoherent secondary to a race where the
	uninhabited portion chooses to become inhabited.

We see the issue over a large range of production systems running
standard RHEL5 kernels all the way up to recent versions of Fedora.
Interestingly the mismatch counts are always an exact multiple of 128
on all the systems.

We have also isolated the problem to be RAID1 and independent of the
backing store.  We run geographical mirrors where an initiator is fed
from two separate data-centers where each mirror half is based on a
RAID5 Linux target.  On RAID1 mirrors which are mismatched the two
separate RAID5 backing volumes both report completely consistent
volumes.

So there is the situation as I believe it currently stands.

The notion of running the 'check' sync_action is well founded.  The
issue of 'silent' data corruption is well understood and well founded.
The Linux RAID system as of a couple of years ago will re-write any
sectors which come up as unreadable during the check process.  Disk
drives will re-allocate a sector from their re-mapping pool
effectively replacing the bad sector.  This pays huge dividends with
respect to maintaining healthy RAID farms.

Unfortunately the report of the mismatch_cnt's is problematic given
the above issues.  I think it is unfortunate the vendors opted to
release this checking/reporting while these issues are still unresolved.

> thanks in advance.
> regards.
> 
> -- 
>   Levente                               "Si vis pacem para bellum!"

Hope the above information is helpful for everyone running into this
issue.

Best wishes for a productive remainder of the week to everyone.

Greg

}-- End of excerpt from Farkas Levente

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Experience is something you don't get until just after you need it."
                                -- Olivier
