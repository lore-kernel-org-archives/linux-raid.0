From: "Simon Jackson" <sjackson@bluearc.com>
Subject: RE: mdadm message (auto-read-only) on "/dev/md1" = swap file system
Date: Thu, 11 Jun 2009 11:00:23 +0100
Message-ID: <3D76E016F4A2A749A1EB1A3FD83E22BC0294AB85@uk-email.terastack.bluearc.com>
References: <2b91784d0906101010l409c38d2m8d0e7401c454307f@mail.gmail.com> <D081A9AE-6E07-4568-880A-2CC8A47947C1@crc.id.au> <2b91784d0906101223m2c8e2c2fh9cd2981480623463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <2b91784d0906101223m2c8e2c2fh9cd2981480623463@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Ing. Jair" <jairzhino@gmail.com>, Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The only issue I have seen with this was when I was recovering a disk a=
nd the swap partition was rebuilding when my system reset for another r=
eason.  On reboot, the swap partition was marked auto-read-only and the=
 recovering member was marked as hot spare, but was not recovering.  On=
ce I used mdadm --readwrite /dev/md2, the hot spare was immediately rec=
overed.

Simon.

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Ing. Jair
Sent: 10 June 2009 20:24
To: Steven Haigh
Cc: linux-raid@vger.kernel.org
Subject: Re: mdadm message (auto-read-only) on "/dev/md1" =3D swap file=
 system

Thank you very much Steven for your reply. I am not having any issues
since the two drives are working fine.  But my concern was if this
will cause problems if in the future I have a hard drive failure.

=3D)

Thank you again,

On Wed, Jun 10, 2009 at 12:30 PM, Steven Haigh<netwiz@crc.id.au> wrote:
> On 11/06/2009, at 3:10 AM, Ing. Jair wrote:
>
>> Dear Linux -raid community masters,
>>
>>
>> I have a quick question regarding something i noticed on my first ti=
me
>> mdadm linux raid configuration server:
>>
>>
>> Current System:
>>
>> Debian Lenny 5.0
>> Two 250GB hard drives identical brand, size, model, speed, etc... th=
ey
>> are the same.
>> 3GB memory ram
>> 1 AMD athlon 2500 CPU
>>
>> Here I am pasting an example of another machine I configure with the
>> same result notice the "(auto-read-only)" message on the swap file
>> system:
>>
>>
>> md2 : active raid1 hde3[0] hdg3[1]
>> =A0 =A0 153557184 blocks [2/2] [UU]
>>
>> md1 : active (auto-read-only) raid1 hde2[0] hdg2[1]
>> =A0 =A0 2634560 blocks [2/2] [UU]
>>
>>
>>
>> md0 : active raid1 hde1[0] hdg1[1]
>> =A0 =A0 96320 blocks [2/2] [UU]
>>
>> unused devices: <none>
>>
>>
>> My question for this is:
>>
>> 1. Is this the way suppose to work on the device md1 =3D swap filesy=
stem
>> raid?
>
> I believe the array will stay read-only until the first write is perf=
ormed -
> at which time the array will automatically switch to read/write.
>
>> 2. If this is normal where can I find documentation about the
>> different "messages" displayed on the command "cat /proc/mdstat"?
>>
>> 3. If this is a bug, is there a work around and what will happen if
>> this continue to appear?
>>
>> 4. I ran the command mdadm -w /dev/md1 and the message disappear, bu=
t
>> after rebooting the system came back up.
>>
>> I appreciate any information or document, links, ideas you can provi=
de to
>> me.
>
>
> The following bug report shows this behaviour, and the reply shows th=
is
> behaviour as 'not a bug'.
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D464560
>
> I can't find any more solid references to this however... This being =
said,
> logic says that if this is correct, the array would only go read/writ=
e when
> something writes to your swap space...
>
> --
> Steven Haigh
>
> Email: netwiz@crc.id.au
> Web: http://www.crc.id.au
> Phone: (03) 9001 6090 - 0412 935 897
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Jairzhino Bolivar (Jair)
GNU/Linux & Unix Administrator
Mobile: (312)404-6530
=46ax: (214)602-4405
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
