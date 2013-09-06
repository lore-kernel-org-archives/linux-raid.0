From: Phil Turmel <philip@turmel.org>
Subject: Re: Problem halting raid 1
Date: Fri, 06 Sep 2013 08:18:06 -0400
Message-ID: <5229C7FE.9070408@turmel.org>
References: <CABcjxUOszUPsEJu_nCSRwzCCy5ijs9YUb0ia8HbZ6kzW-jCwWA@mail.gmail.com> <5229BE99.4070701@turmel.org> <CABcjxUMBp=oZ7Dg65ZK4ft-Jix4kAi=VV3juE1KWRkw8RnYKyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABcjxUMBp=oZ7Dg65ZK4ft-Jix4kAi=VV3juE1KWRkw8RnYKyQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWlndWVsIENvcmJlcsOhbiBSdWl6?= <migcorrui@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Miguel,

[Top posting repaired. Please don't do that.]
[linux-raid added back to CC:.  Use reply-to-all on kernel.org lists.]

On 09/06/2013 07:57 AM, Miguel Corber=C3=A1n Ruiz wrote:
> On Fri, Sep 6, 2013 at 1:38 PM, Phil Turmel <philip@turmel.org> wrote=
:
>> Good morning Miguel,
>>
>> On 09/06/2013 06:42 AM, Miguel Corber=C3=A1n Ruiz wrote:
>>> Hello,
>>> I am having a problem stopping an array. When I use the command "md=
adm
>>> --stop /dev/md0" the array disappears completely. It does not even
>>> appear under /dev/m..
>>
>> This is the expected behavior.
>>
>>> Then, when I try "mdadm --remove /dev/md0" bash tells me that /dev/=
md0
>>> does not exist. So, after stopping the array with "mdadm --stop .."=
,
>>> "cat /proc/mdstat" says that there is no array running. From what I
>>> read the array should be visible but in a halted/stopped/deactivate=
d
>>> state. And then one can proceed to remove it.
>>
>> The --remove action is used to remove a failed member from an array,=
 not
>> an array itself.
>>
>>> What I want to do is to completely remove the array so I can mount =
the
>>> individual partitions anywhere else without the need of mdadm (and
>>> access the data created when the array was running).
>>
>> You would use --zero-superblock on each member device to make it
>> "forget" what array it belonged to.

> Hello Phil and thank you for answering,
> If that is the expected behaviour, there are many sites with wrong
> information since the advice to first stop the array and then remove
> it:
>
>
http://blogging.dragon.org.uk/index.php/mini-howtos/howto-remove-raid-a=
rrays
>
> http://en.wikipedia.org/wiki/Mdadm

Those two are wrong.

>
https://wiki.archlinux.org/index.php/RAID#Removing_device.2C_stop_using=
_the_array

This one is correct.

> In the mdadm man page, for the --stop option, it says: "deactivate
> array, releasing all resources."
> It doesn't say that the array is removed or deleted.

Because the array still exists on the disks.  It is just "turned off".

> As for the md superblock zeroing, I have tried to stop, remove and
> zero the superblock of an individual device. But afterwards the
> device's filesystem appears as unknown and I cannot mount it to acces=
s
> the data.
>
> So, accepting things as they are, how can I see the data in a device
> which pertained to an array without creating a degraded array with it=
?

You can't, except in one special case.

The special case is when you had a simple mirror and you now want to us=
e
one of its members by itself (permanently).  If the raid used version
0.9 or version 1.0 metadata, just zeroing the metadata will do what you
want (with some wasted space at the end of the partition).

If the raid used version 1.1 or 1.2 metadata, the contents of the array
are offset from the start of the array member.  You have to shift the
data to the start of the partition, or change the partition definition
to start at the right spot.

HTH,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
