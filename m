From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Use of WD20EARS with MDADM
Date: Thu, 22 Apr 2010 10:51:02 +1000
Message-ID: <7377a3dbc6fd36483758c7c7aeeae55e@localhost>
References: <4BAB8D41.4010801@gmail.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com> <4BCEFB99.9080806@tmr.com> <4BCF163C.6040604@cfl.rr.com> <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com> <4BCF4693.3020101@buttersideup.com> <m2x5bdc1c8b1004211201ob1ea0c67k67b03eb4627a1375@mail.gmail.com> <z2wb7b14cbb1004211231vf34acbf1sf34ccba3160c1688@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <z2wb7b14cbb1004211231vf34acbf1sf34ccba3160c1688@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

+1 Insightful.

This is a gem of a tip - so much so that I've archived the text of this=
 as
I KNOW it will come in handy soon.

It may be been semi-off topic, but it is worth its weight in gold!

Thankyou!

On Wed, 21 Apr 2010 21:31:27 +0200, Clinton Lee Taylor
<clintonlee.taylor@gmail.com> wrote:
> Greetings ...
>=20
> On 21 April 2010 21:01, Mark Knecht <markknecht@gmail.com> wrote:
>> On Wed, Apr 21, 2010 at 11:40 AM, Tim Small <tim@buttersideup.com>
wrote:
>>> Mark Knecht wrote:
>>>> This machine only gets a few hours of use a day but is generally
>>>> powered up all the time. I don't know why Linux wakes this drive u=
p
>>>> roughly every two minutes, assuming it's Linux and not the drive
>>>> itself or something on the motherboard, but it does.
>>>>
>>>
>>>
>>> This is documented here:
>>>
>>>
https://ata.wiki.kernel.org/index.php/Known_issues#Drives_which_perform=
_frequent_head_unloads_under_Linux
>>>
>>> If you want to fix it, then wdidle3.exe worked for me. =C2=A0Search=
 for:
>>>
>>> wdidle3_1_00.zip
>>>
>>>
>>> Tim.
>>>
>>
>> Yeah, that's been reported here before, but how does someone run thi=
s
>> Windows program on a remote machine that boots only Linux? Even if i=
t
>> was a DOS executable the machine has no floppy. I presume you are
>> dual-boot with Windows? If so maybe I'll install Windows the next ti=
me
>> I visit.
>  Why don't you download FreeDOS boot floppy image.  Add the DOS
> program to the image. Copy image to your boot partition, add an entry
> in your Boot Manager to boot the image using some line syslinux image
> booter.
>=20
> On CentOS, install syslinux package using "yum install syslinux"
> Copy memdisk to your boot partition
>=20
> From the www.freedos.org web site, download floppy image in
> http://www.freedos.org/freedos/files/ ...
>=20
> wget -vb
>
http://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1=
=2E0/fdboot.img
>=20
> Mount the downloaded image file with "mount fdboot.img /mnt/floppy/ -=
o
> rw,loop"
>=20
> Copy DOS program into the floppy image.
>=20
> Add to your grub.conf file ...
>=20
> title FreeDOS - Boot Image
>     kernel memdisk
>     initrd fdboot.img
>=20
> Now reboot your system that does not have a floppy drive off the
> FreeDOS image and run the DOS program to make changes.  The only thin=
g
> I can think of that might be a problem, is that you might have the
> drive attached to a SATA port that is not supported by the DOS progra=
m
> or something like that.
>=20
> This is what I use to do BIOS and other firmware updates, that Linux
> does not have a tool for.
>=20
> Mailed
> LeeT
>=20
> P.S. Sorry for the Off Topic post, but I hope it helps.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Steven Haigh
=20
Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
=46ax: (03) 8338 0299
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
