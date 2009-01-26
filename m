From: Greg Freemyer <greg.freemyer@norcrossgroup.com>
Subject: Re: SSD data reliable vs. unreliable [Was: Re: Data Recovery from
	SSDs - Impact of trim?]
Date: Mon, 26 Jan 2009 13:09:05 -0500
Message-ID: <87f94c370901261009w431156fbx4d2b20638dc5097c@mail.gmail.com>
References: <87f94c370901221553p4d3a749fl4717deabba5419ec@mail.gmail.com>
	 <497A2B3C.3060603@redhat.com>
	 <1232749447.3250.146.camel@localhost.localdomain>
	 <87f94c370901231526jb41ea66ta1d6a23d7631d63c@mail.gmail.com>
	 <497A542C.1040900@redhat.com>
	 <7fce22690901260659u30ffd634m3fb7f75102141ee9@mail.gmail.com>
	 <497DE35C.6090308@redhat.com>
	 <87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>
	 <497DF807.7010600@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <497DF807.7010600@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Dongjun Shin <djshin90@gmail.com>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 26, 2009 at 12:51 PM, Mark Lord <liml@rtr.ca> wrote:
> Greg Freemyer wrote:
>>
>> Seems to introduce some huge layering violations for Raid 5 / 6
>> implementations using next generation SSDs to comprise the raid
>> volumes.
>
> ..
>
> Possibly so.  But having stripe layouts known to the fs layer
> is a *good* thing, and is pretty much already necessary for decent
> filesystem performance.  It would be better even, if the filesystem
> would just automatically pick up that information, rather than
> relying upon mkfs parameters (maybe they already do now ?).
>
>> Allowing data to change from the SATA / SAS interface layer and not
>> implementing a signaling mechanism that allows the kernel (or any OS /
>> software tool) to ask which sectors / blocks / erase units have
>> undergone data changes is just bizarre to me.
>
> ..
>
> I think that's just blowing smoke.  The only sectors/blocks/erase-units
> which
> even *might* undergo such changes, are already restricted to those exact
> units which the kernel itself specificies (by explicitly discarding them).
> If we care about knowing which ones later on (and we don't, generally),
> then we (kernel) can maintain a list, just like we do for other such
> entities.
>
> I don't see much of a downside here for any normal users of filesystems.
> This kind of feature is long overdue.
>
> Cheers
>

Just so I know and before I try to find the right way to comment to
the T13 and T10 committees:

What is the negative of adding a ATA/SCSI command to allow the storage
device to be interrogated to see what sectors/blocks/erase-units are
in a mapped vs. unmapped state?

For T13 (ATA), it would actually be a tri-state flag I gather:

  Mapped - last data written available
  unmapped - no data values assigned
  unmapped - deterministic data values

Surely the storage device has to be keeping this data internally.  Why
not expose it?

For data recovery and computer forensics purposes I would actually
prefer even finer grained info, but those 3 states seem useful for
several layers of the filesystem stack to be able to more fully
optimize what they are doing.

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
