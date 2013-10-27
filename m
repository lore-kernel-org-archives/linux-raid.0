From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: changing parameters of a running array?
Date: Sun, 27 Oct 2013 21:28:06 +0400
Message-ID: <526D4D26.90808@msgid.tls.msk.ru>
References: <526A2034.2050103@msgid.tls.msk.ru> <20131025111248.8fcd1cb5912e51c54f67f733@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131025111248.8fcd1cb5912e51c54f67f733@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

25.10.2013 13:12, Lars T=E4uber wrote:
> Hi Michael,
>
> Fri, 25 Oct 2013 11:39:32 +0400
> Michael Tokarev <mjt@tls.msk.ru> =3D=3D> linux-raid <linux-raid@vger.=
kernel.org> :
>> Hello.
>>
>> Is there a way to change some parameters - like preferred minor,
>> array name, homehost, guuid and the like - of a _running_ array?
>> I understand these can be changed using --assemble --update=3Dfoo,
>> but how about, say, root array which is being assembled from
>> within an initrd with limited functionality?
>>
>> What I'm trying to achieve is to make a clone of a (remote)
>> running system, in order to upgrade hdds.  For this, a new
>> set of drives are inserted, new set of filesystems is created,
>> current filesystems are copied to new hdds and on the next
>> reboot the system should boot from the new hdds.  But since
>> I can't create arrays with the same names/minors as currently
>> running ones, and I want to preserve the naming scheme, I
>> need to ensure the new arrays will be named correctly after
>> the reboot.  But since the system is remote, this is a bit
>> difficult to achieve for the root device.
>>
>> And similarly, I can't --update a NON-running array without
>> --assemble, so I can't fix the names before reboot while the
>> old arrays are still running.
>>
>> Maybe the easiest way is to write a small (perl) program
>> which will read the superblock of a non-running array, update
>> it and write it back.  This at least will allow me to perform
>> tasks before reboot.  But this way it becomes risky - if the
>> first reboot will happen with the old drives still in place,
>> havoc might happen, since more than one array will have the
>> same name...
>>
>> So a better route will be to create new arrays with temp
>> names, reboot, change names on the newly running system,
>> and remove old arrays.  The question is how to change
>> some params on a running system.
>>
>
> it depends on the distribution you're running. But you might not need=
 to change these parameters while the system is running.

It doesn't.  One thing is the name forcible used to assemble
an array -- this one indeed depends on the initrd/initramfs
in use.  And another thing is the name recorded in the array
superblock -- this does not and should not chage behind my
back.  It should only change explicitly.  And that's exactly
what I'm talking about -- how to explicitly change some
params when the array is in use.

Thanks,

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
