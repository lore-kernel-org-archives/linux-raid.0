From: Phil Turmel <philip@turmel.org>
Subject: Re: linux raid wiki - backup files
Date: Mon, 21 Nov 2016 16:40:18 -0500
Message-ID: <f5f7a9bf-9a6f-7b97-dfc4-63335e07d0db@turmel.org>
References: <583077D0.5070804@youngman.org.uk>
 <ffb47575-b655-924d-8626-07b9e48a6371@turmel.org>
 <5831B7B9.8090008@youngman.org.uk>
 <4febebb6-0442-cc5e-45d5-e041e21e2d95@turmel.org>
 <c3d16a30-b36e-3d26-f30a-441b236f7107@youngman.org.uk>
 <177d8cfb-f7ec-b0e4-040f-3cfb55f033cc@turmel.org>
 <980f8ae9-124e-e10c-afc2-97eef9e05b94@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <980f8ae9-124e-e10c-afc2-97eef9e05b94@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>, neilb@suse.com
List-Id: linux-raid.ids

On 11/21/2016 04:30 PM, Anthony Youngman wrote:
> So basically, there's no point using 1.0 for any form of parity raid. In
> which case, if you convert a mirror to parity, it would be nice to be
> able to create said offset and move the superblock.

Not for new parity arrays, no.  v1.0 is what you get if you convert an
old v0.90 array to v1.x using --assemble --update=metadata.  I simply
don't know if a v1.0 superblock will run with a non-zero data offset.
That would have to be an intermediate step before the superblock and the
rest of the metadata could be relocated.

>> V1.1 and v1.2 are identical except for the superblock offset (one 4k
>> block difference).  v1.1 reshapes just like v1.2.
>>
> Any reason for that difference? How big is the superblock? Did v1.1 fill
> most of the first 4K and just leave not much room with a default 4K data
> offset initially?

v1.1 places the superblock in the first sector of the device.  v1.2
skips the first 4k, making such arrays resistant to destruction by
accidental creation of MBR partition tables or similar crises.

Phil
