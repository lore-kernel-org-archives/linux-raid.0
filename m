From: Martin Ritchie <ritchiem@mac.com>
Subject: Re: Newbie questions: Max Active disks, RAID migration, Compiling mdadm 2.3
Date: Sun, 5 Feb 2006 22:41:51 +0000
Message-ID: <7D3A6EBD-6C6D-44B5-BE1C-24BBDB2B391A@mac.com>
References: <Pine.LNX.4.44.0602051634590.14014-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=WINDOWS-1252;
	delsp=yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0602051634590.14014-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can see what I did now. Very silly.

I created a RAID 5 with 4 disks then went about hot adding disks. =20
Silly me thinking it would increase the active space. Of course with =20
the parity being shared through the active disks this doesn't makes =20
sense.

I was wanting to define a systematic way that I could start with a =20
small number of disks and then expand the RAID as I needed more space =20
(and could afford more disks).

Is raidreconf the only way for reconfiguring a live system?

Cheers
--=20
Martin

"What we do in life, echoes in Eternity."
-Maximus Decimus Meridius



On Feb 05, 2006, at 21:40, Mark Hahn wrote:

>> Why can't I have more than 4 active drives in my md RAID?
>
> why do you think you can't?
>
>> Why can't I easily migrate a RAID 0 to RAID 5. As I see it RAID 0 is
>> just RAID 5 with a failed parity check drive?
>
> that would be raid3, actually.  with r5, the parityblock rotates
> among all drives.
>
>> $make
>> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf=
=20
>> \" -
>> ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o super0.o super=
0.c
>> In file included from super0.c:31:
>> /usr/include/asm/byteorder.h:6:2: error: #warning using private
>> kernel header; include <endian.h> instead!
>
> that's a bug in FC's includes, nothing to do with MD.
>
>> $make
>> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf=
=20
>> \" -
>> ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o super0.o super=
0.c
>> cc1: warnings being treated as errors
>> super0.c: In function =91add_internal_bitmap0=92:
>> super0.c:737: warning: implicit declaration of function =20
>> =91__cpu_to_le32=92
>> super0.c:742: warning: implicit declaration of function =20
>> =91__cpu_to_le64=92
>> make: *** [super0.o] Error 1
>
> I'd guess that MD sources should include -D__KERNEL__ in order to
> get those functions, or else include its own definitions.
>
>> Oh just because I know it is going to be an issue I'm building on a
>> Athlon 64... my first 64bit linux box so I'm sure there are going to
>> be gotchas that I've not thought about.
>
> LOTS of people have k8 boxes by now; it's not possible you're seeing
> anything really new...
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
