From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID halting
Date: Sun, 5 Apr 2009 16:00:39 -0400
Message-ID: <87f94c370904051300x531acb1fqb55319536333c01f@mail.gmail.com>
References: <20090405185421.RJPR28081.cdptpa-omta04.mail.rr.com@Leslie>
	 <49D903BA.8000000@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D903BA.8000000@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: lrhorer@satx.rr.com, Drew <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 5, 2009 at 3:17 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 05/04/2009 19:54, Leslie Rhorer wrote:
>>>>
>>>> The problem started immediately the last time I
>>>> rebuilt the array and formatted it as Reiserfs, after moving the d=
rives
>>>> out of the old RAID chassis.
>>>
>>> What file system were you using before ReiserFS?
>>
>> Several, actually. =A0Since the RAID array kept crashing, I had to r=
e-create
>> it numerous times.
>
> [...]
>>>
>>> your culprit is higher up the chain, ie the FS.
>>
>> I've suspected this may be the case from the outset.
>
> I'm sorry? You've repeatedly had trouble with this system, this array=
,
> you've tried several filesystems; do you think they're *ALL* broken?
>
> Cheers,
>
> John.

I for one think it is very reasonable that Leslie may have experienced
numerous different problems in the course of trying to put together a
large scale raid system for video editing.

But Leslie, maybe you do need to take a step back and review your
overall design and see what major changes you could make that might
help.

I'm not really keeping up with things like video editing, but as
someone else said XFS was specifically designed for that type of
workload.  It even has a psuedo realtime capability to ensure you
maintain your frame rate, etc.  Or so I understand.  I've never used
that feature.  You could also evaluate the different i/o elevators.

If I were designing a system like you have for myself, I would get one
of the major supported server distros.  (I'm a SuSE fan, so I would go
with SLES, but I assume others are good as well.)  Then I would get
hardware they specifically support and I would use their best practice
configs.  Neil Brown has a suse email address, maybe he can tell you
where to find some suse supported config documents, etc.

=46YI: Some of the major problems going in the last year that make me
willing to believe someone is having lots of unrelated issues in
trying to build a system like Leslie's.

=3D=3D
Reiser's main maintainer is in jail, recent versions of OpenSUSE croak
if reiser is in use because they exercise code paths with serious
bugs. (google "beagle opensuse reiser")

Ext3 is being savaged on the various LKML lists as we speak due to
horrible latency issues with workloads similar to Leslie's.

The latest Linus kernel has a lot ext3 patches in it that reduce the
horrible latency to merely unacceptable.  Linus and Ted Tso are now
thinking the remaining problems are with the CFQ elevator.  (In theory
the AS one is better, but the troubleshooting is ongoing as we speak,
so too soon to say anything definitive just yet.)

Seagate drives have been having major firmware issues for about a year.

Marvell PMP linux kernel support has just been promoted from
experimental recently (if that has even happened yet.)  And Marvell is
used on lot of MBs.

Sil's have a known problem that if the first drive on a PMP is
missing, it screws up the rest of the drives.

Ext4 is claimed "production" but is getting major corruption bugzillas
(and associated patches) weekly.  I for one would not use it for
production work.

Tejun Heo is the core eSata developer and he says not to trust any
eSata cable a meter or longer.  ie. He had lots of spurious
transmission errors when testing with longer cables.

Lot of reported problems turn out to be power supplies not designed to
carry a Sata load.  Apparently sata drives are very demanding and many
"good" power supplies don't cut the mustard.

and that is off the top of my head.


Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
