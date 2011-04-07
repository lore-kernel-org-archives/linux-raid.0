From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: 4-disk raid5 with 2 disks going bad: best way to proceed?
Date: Thu, 7 Apr 2011 00:35:04 -0300
Message-ID: <BANLkTin0FnFDd9++wgG_7hcKMe8wqqeEbQ@mail.gmail.com>
References: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rob pfile <rpfile@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i'm not a master expert with linux raid, but... stop array, add 2 new
disks and make a backup (dd) of two bad disks, start array with the
new disks (must be same size)
(i don't know if raid5 have spare disks and how they work, maybe
there's a 'online' solution without stopping array)
maybe others guys here could help you better, but this one works :)

2011/4/6 rob pfile <rpfile@gmail.com>:
> Hi all,
>
> any collective wisdom on what to do here? i've got a 4-disk raid5, an=
d the most recent checkarray showed several bad blocks caused by uncorr=
ectable read errors on two of the disks in the array. both disks in que=
stion show 0 reallocated sectors, but one looks like this:
>
> 197 Current_Pending_Sector =A00x0032 =A0 200 =A0 200 =A0 000 =A0 =A0O=
ld_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
> 198 Offline_Uncorrectable =A0 0x0030 =A0 200 =A0 200 =A0 000 =A0 =A0O=
ld_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 16
> 199 UDMA_CRC_Error_Count =A0 =A00x0032 =A0 200 =A0 200 =A0 000 =A0 =A0=
Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
> 200 Multi_Zone_Error_Rate =A0 0x0008 =A0 200 =A0 200 =A0 000 =A0 =A0O=
ld_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 16
>
> and the other like this:
>
> 197 Current_Pending_Sector =A00x0032 =A0 200 =A0 200 =A0 000 =A0 =A0O=
ld_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 14
> 198 Offline_Uncorrectable =A0 0x0030 =A0 200 =A0 200 =A0 000 =A0 =A0O=
ld_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 3
> 199 UDMA_CRC_Error_Count =A0 =A00x0032 =A0 200 =A0 200 =A0 000 =A0 =A0=
Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
> 200 Multi_Zone_Error_Rate =A0 0x0008 =A0 200 =A0 200 =A0 000 =A0 =A0O=
ld_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 11
>
> i'm a bit worried about failing one of these disks for fear that the =
other might give uncorrectable read errors during the rebuild. if i *ha=
d* to choose one, should i choose the one with all the pending sectors,=
 or the one with all the uncorrectable sectors?
>
> does it makes sense to do a smartctl -t offline scan on one or both o=
f these disks first?
>
> i guess i could take the array offline, clone one of the disks with d=
d, and then swap the clone in. but... is there a way to clone one disk =
in the array using mdadm? in other words, is there a way to construct a=
 clean copy of one of the disks even if there are raid-correctable read=
 errors?
>
> i do have backups, so perhaps it will not kill me if the array dies, =
but i'd like to tread carefully and try and get out of this mess withou=
t nuking everything.
>
> thanks for any advice,
>
> rob
>
>
>
>
>
>
>
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
