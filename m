From: Greg Freemyer <greg.freemyer@norcrossgroup.com>
Subject: Re: SSD data reliable vs. unreliable [Was: Re: Data Recovery from
	SSDs - Impact of trim?]
Date: Mon, 26 Jan 2009 12:34:33 -0500
Message-ID: <87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>
References: <87f94c370901221553p4d3a749fl4717deabba5419ec@mail.gmail.com>
	 <497A2B3C.3060603@redhat.com>
	 <1232749447.3250.146.camel@localhost.localdomain>
	 <87f94c370901231526jb41ea66ta1d6a23d7631d63c@mail.gmail.com>
	 <497A542C.1040900@redhat.com>
	 <7fce22690901260659u30ffd634m3fb7f75102141ee9@mail.gmail.com>
	 <497DE35C.6090308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <497DE35C.6090308@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Dongjun Shin <djshin90@gmail.com>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Adding mdraid list:

Top post as a recap for mdraid list (redundantly at end of email if
anyone wants to respond to any of this).:

== Start RECAP
With proposed spec changes for both T10 and T13 a new "unmap" or
"trim" command is proposed respectively.  The linux kernel is
implementing this as a sector discard and will be called by various
file systems as they delete data files.  Ext4 will be one of the first
to support this. (At least via out of kernel patches.)

SCSI - see http://www.t10.org/cgi-bin/ac.pl?t=d&f=08-356r5.pdf
ATA - see T13/e08137r2 draft

Per the proposed spec changes, the underlying SSD device can
optionally modify the unmapped data.  SCSI T10 at least restricts the
way the modification happens, but data modification of unmapped data
is still definitely allowed for both classes of SSD.

Thus if a filesystem "discards" a sector, the contents of the sector
can change and thus parity values are no longer meaningful for the
stripe.

ie. If the unmap-ed blocks don't exactly correlate with the Raid-5 / 6
stripping, then the integrity of a stripe containing both mapped and
unmapped data is lost.

Thus it seems that either the filesystem will have to understand the
raid 5 / 6 stripping / chunking setup and ensure it never issues a
discard command unless an entire stripe is being discarded.  Or that
the raid implementation must must snoop the discard commands and take
appropriate actions.

FYI:
In T13 a feature bit will be provided to identify ATA SSDs that
implement a "deterministic" feature.  Meaning that once you read a
specific unmapped sector, its contents will not change until written
but that does not change the fact that a discard command that does not
perfectly match the raid setup may destroy the integrity of a stripe.

I believe all T10 (SCSI) devices with be deterministic by spec.

End of RECAP

On Mon, Jan 26, 2009 at 11:22 AM, Ric Wheeler <rwheeler@redhat.com> wrote:
> Greg Freemyer wrote:
>>
>> On Fri, Jan 23, 2009 at 6:35 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
>>
>>>
>>> Greg Freemyer wrote:
>>>
>>>>
>>>> On Fri, Jan 23, 2009 at 5:24 PM, James Bottomley
>>>> <James.Bottomley@hansenpartnership.com> wrote:
>>>>
>>>>
>>>>>
>>>>> On Fri, 2009-01-23 at 15:40 -0500, Ric Wheeler wrote:
>>>>>
>>>>>
>>>>>>
>>>>>> Greg Freemyer wrote:
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Just to make sure I understand, with the proposed trim updates to the
>>>>>>> ATA spec (T13/e08137r2 draft), a SSD can have two kinds of data.
>>>>>>>
>>>>>>> Reliable and unreliable.  Where unreliable can return zeros, ones,
>>>>>>> old
>>>>>>> data, random made up data, old data slightly adulterated, etc..
>>>>>>>
>>>>>>> And there is no way for the kernel to distinguish if the particular
>>>>>>> data it is getting from the SSD is of the reliable or unreliable
>>>>>>> type?
>>>>>>>
>>>>>>> For the unreliable data, if the determistic bit is set in the
>>>>>>> identify
>>>>>>> block, then the kernel can be assured of reading the same unreliable
>>>>>>> data repeatedly, but still it has no way of knowing the data it is
>>>>>>> reading was ever even written to the SSD in the first place.
>>>>>>>
>>>>>>> That just seems unacceptable.
>>>>>>>
>>>>>>> Greg
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> Hi Greg,
>>>>>>
>>>>>> I sat in on a similar discussion in T10 . With luck, the T13 people
>>>>>> have
>>>>>> the same high level design:
>>>>>>
>>>>>> (1) following a write to sector X, any subsequent read of X will
>>>>>> return
>>>>>> that data
>>>>>> (2) once you DISCARD/UNMAP sector X, the device can return any state
>>>>>> (stale data, all 1's, all 0's) on the next read of that sector, but
>>>>>> must
>>>>>> continue to return that data on following reads until the sector is
>>>>>> rewritten
>>>>>>
>>>>>>
>>>>>
>>>>> Actually, the latest draft:
>>>>>
>>>>> http://www.t10.org/cgi-bin/ac.pl?t=d&f=08-356r5.pdf
>>>>>
>>>>> extends this behaviour: If the array has read capacity(16) TPRZ bit set
>>>>> then the return for an unmapped block is always zero.  If TPRZ isn't
>>>>> set, it's undefined but consistent.  I think TPRZ is there to address
>>>>> security concerns.
>>>>>
>>>>> James
>>>>>
>>>>>
>>>>
>>>> To James,
>>>>
>>>> I took a look at the spec, but I'm not familiar with the SCSI spec to
>>>> grok it immediately.
>>>>
>>>> Is the TPRZ bit meant to be a way for the manufacturer to report which
>>>> of the two behaviors their device implements, or is it a externally
>>>> configurable flag that tells the SSD which way to behave?
>>>>
>>>> Either way, is there reason to believe the ATA T13 spec will get
>>>> similar functionality?
>>>>
>>>> To Ric,
>>>>
>>>> First, in general I think is is bizarre to have a device that is by
>>>> spec able to return both reliable and non-reliable data, but the spec
>>>> does not include a signaling method to differentiate between the two.
>>>>
>>>> ===
>>>> My very specific concern is that I work with evidence that will
>>>> eventually be presented at court.
>>>>
>>>> We routinely work with both live files and recoved deleted files
>>>> (Computer Forensic Analysis).  Thus we would typically be reading the
>>>> discarded sectors as well as in-use sectors.
>>>>
>>>> After reading the original proposal from 2007, I assumed that a read
>>>> would provide me either data that had been written specifically to the
>>>> sectors read, or that the SSD would return all nulls.  That is very
>>>> troubling to the ten thousand or so computer forensic examiners in the
>>>> USA, but it true we just had to live with it.
>>>>
>>>> Now reading the Oct. 2008 revision I realized that discarded sectors
>>>> are theoretically allowed to return absolutely anything the SSD feels
>>>> like returning.  Thus the SSD might return data that appears to be
>>>> supporting one side of the trial or the other, but it may have been
>>>> artificially created by the SSD.  And I don't even have a flag that
>>>> says "trust this data".
>>>>
>>>> The way things currently stand with my understanding of the proposed
>>>> spec. I will not be able to tell the court anything about the
>>>> reliability of any data copied from the SSD regardless of whether it
>>>> is part of an active file or not.
>>>>
>>>> At its most basic level, I transport a typical file on a SSD by
>>>> connecting it to computer A, writing data to it, disconnecting from A
>>>> and connecting to computer B and then print it from there for court
>>>> room use.
>>>>
>>>> When I read that file from the SSD how can I assure the court that
>>>> data I read is even claimed to be reliable by the SSD?
>>>>
>>>>  ie. The SSD has no way to say "I believe this data is what was
>>>> written to me via computer A" so why should the court or anyone else
>>>> trust the data it returns.
>>>>
>>>> IF the TPRZ bit becomes mandatory for both ATA and SCSI SSDs, then if
>>>> it is set I can have confidence that any data read from the device was
>>>> actually written to it.
>>>>
>>>> Lacking the TPRZ bit, ...
>>>>
>>>> Greg
>>>>
>>>>
>>>
>>> I think that the incorrect assumption here is that you as a user can read
>>> data that is invalid. If you are using a file system, you will never be
>>> able
>>> to read those unmapped/freed blocks (the file system will not allow it).
>>>
>>> If you read the raw device as root, then you could seem random bits of
>>> data
>>> - maybe data recovery tools would make this an issue?
>>>
>>> ric
>>>
>>
>> Ric,
>>

<snip>

> This seems to be overstated. The file system layer knows what its valid data
> is at any time and will send down unmap/trim commands only when it is sure
> that the block is no longer in use.
>
> The only concern is one of efficiency/performance - the commands are
> advisory, so the target can ignore them (i.e., not pre-erase them or
> allocate them in T10 to another user). There will be no need for fsck to
> look at unallocated blocks.
>
> The concern we do have is that RAID and checksums must be consistent. Once
> read, the device must return the same contents after a trim/unmap so as not
> to change the parity/hash/etc.

===> Copy of top post
With proposed spec changes for both T10 and T13 a new "unmap" or
"trim" command is proposed respectively.

SCSI - see http://www.t10.org/cgi-bin/ac.pl?t=d&f=08-356r5.pdf
ATA - T13/e08137r2 draft

Per the proposed spec changes, the underlying SSD device can
optionally modify the unmapped data at its discretion.  SCSI T10
atleast restricts the way the modification happens, but data
modification of unmapped data is still definitely allowed.

Thus if a filesystem "discards" a sector, the contents of the sector
can change and thus parity values are no longer meaningful for the
stripe.

ie. If the unmap-ed blocks don't exactly correlate with the Raid-5 / 6
stripping, then the integrity of a stripe containing both mapped and
unmapped data is lost.

A feature bit will be provided to identify SSDs that implement a
"stable value on read" feature.  Meaning that once you read a specific
unmapped sector, its contents will not change until written but that
does not change the fact that a discard command that does not
perfectly match the raid setup may destroy the integrity of a stripe.

Thus it seems that either the filesystem will have to understand the
raid 5 / 6 stripping / chunking setup and ensure it never issues a
discard command unless an entire stripe is free.  Or that the raid
implementation must must snoop the discard commands and take
appropriate actions.
===> END Copy of top post

Seems to introduce some huge layering violations for Raid 5 / 6
implementations using next generation SSDs to comprise the raid
volumes.

I imagine writing reshaping software is hard enough without this going on.

<snip>

> One serious suggestion is that you take your concerns up with the T13 group directly - few people on this list sit in on those, I believe that it is an open forum.

I will have to look into that.  The whole idea of what is happening
here seems fraught with problems to me.  T13 is worse than T10 from
what I see, but both seem highly problematic.

Allowing data to change from the SATA / SAS interface layer and not
implementing a signaling mechanism that allows the kernel (or any OS /
software tool) to ask which sectors / blocks / erase units have
undergone data changes is just bizarre to me.

I the unmap command always caused the unmap sectors to return some
fixed value, at least that could be incorporated into a raid
implementations logic.

The current random nature of what unmap command does is very unsettling to me.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
