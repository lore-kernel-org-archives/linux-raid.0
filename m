From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Guidance on how to best assemble new root drive?
Date: Sat, 1 Jan 2011 17:24:01 -0800
Message-ID: <AANLkTimYmmhHYybvQ_mdDxizd9Qe2Qc6RrPbY-8zAUhX@mail.gmail.com>
References: <AANLkTi=eU7Z8OaiAkEkatoN3-U67LEYcB5reB1f27QyU@mail.gmail.com>
	<4D1F8E3C.1000006@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D1F8E3C.1000006@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 1, 2011 at 12:27 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 01/01/2011 19:47, Mark Knecht wrote:
> [...]
>>
>> Is there a way to rename the array in the SuperBlock?
>
> mdadm --update=homehost
> mdadm --update=name
>
>> Should I bother? I may go back and forth between these two Gentoo
>> installations for a while and want the RAID to be available in both,
>> at least until I delete the old RAID1 system to recapture the disk
>> space.
>
> I wouldn't have changed hostname, but if your new root is on the RAID-6 yes
> I'd change its homehost to suit its hostname. You will then have to tell the
> old RAID-1 to start the array using the new homehost.
>
> Cheers,
>
> John.

Hey John,
   Thanks for the response and the commands above. Makes sense.

   There really isn't any reason I had to change the name. I just did
it so I'd be clear which environment I was working in if one was in a
chroot. I could easily change it to c2stable.

   However that name is a Gentoo machine name that doesn't get set (I
think) until much later in a real boot. At the point where the kernel
is trying to find the devices and assembling the RAID6 I don't think
it knows anything about the machine name does it? This is really early
on in the boot process. It has to read the RAID6 to figure out what
the machine name will eventually be...

   I suspect that the other way I could tell mdadm to assemble is
based on the explicit disk name and partition number. However I
thought mdadm was going to search all the Super Blocks and figure that
out as these are bright & shiny 1.2 Super Blocks. Guess I was wrong
about that. Rereading the man page I suspect this feature is to
protect from assembling partitions that below to some other machine or
something. I don't understand how they get used in a PC at boot time,
but PCs are a small part of what mdadm supports.

   I do appreciate the response.

Cheers,
Mark
