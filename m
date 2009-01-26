From: Mark Lord <liml@rtr.ca>
Subject: Re: SSD data reliable vs. unreliable [Was: Re: Data Recovery from
 	SSDs - Impact of trim?]
Date: Mon, 26 Jan 2009 12:51:03 -0500
Message-ID: <497DF807.7010600@rtr.ca>
References: <87f94c370901221553p4d3a749fl4717deabba5419ec@mail.gmail.com>	 <497A2B3C.3060603@redhat.com>	 <1232749447.3250.146.camel@localhost.localdomain>	 <87f94c370901231526jb41ea66ta1d6a23d7631d63c@mail.gmail.com>	 <497A542C.1040900@redhat.com>	 <7fce22690901260659u30ffd634m3fb7f75102141ee9@mail.gmail.com>	 <497DE35C.6090308@redhat.com> <87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@norcrossgroup.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Dongjun Shin <djshin90@gmail.com>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Greg Freemyer wrote:
>
> Seems to introduce some huge layering violations for Raid 5 / 6
> implementations using next generation SSDs to comprise the raid
> volumes.
..

Possibly so.  But having stripe layouts known to the fs layer
is a *good* thing, and is pretty much already necessary for decent
filesystem performance.  It would be better even, if the filesystem
would just automatically pick up that information, rather than
relying upon mkfs parameters (maybe they already do now ?).

> Allowing data to change from the SATA / SAS interface layer and not
> implementing a signaling mechanism that allows the kernel (or any OS /
> software tool) to ask which sectors / blocks / erase units have
> undergone data changes is just bizarre to me.
..

I think that's just blowing smoke.  The only sectors/blocks/erase-units which
even *might* undergo such changes, are already restricted to those exact
units which the kernel itself specificies (by explicitly discarding them).
If we care about knowing which ones later on (and we don't, generally),
then we (kernel) can maintain a list, just like we do for other such entities.

I don't see much of a downside here for any normal users of filesystems.
This kind of feature is long overdue.

Cheers
