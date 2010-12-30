From: James <jtp@nc.rr.com>
Subject: Re: read errors corrected
Date: Thu, 30 Dec 2010 11:41:18 -0500
Message-ID: <AANLkTimm6P=Lb1uzC83Va323V+Q0e1xSzFfuc2ze-8Fp@mail.gmail.com>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com> <4D1C5B4F.8050506@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D1C5B4F.8050506@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Inline.

On Thu, Dec 30, 2010 at 05:13, Giovanni Tessore <giotex@texsoft.it> wro=
te:
> On 12/30/2010 04:20 AM, James wrote:
>>
>> Can someone point me in the right direction?
>> (a) what causes these errors precisely?
>> (b) is the error benign? How can I determine if it is *likely* a
>> hardware problem? (I imagine it's probably impossible to tell if it'=
s
>> HW until it's too late)
>> (c) are these errors expected in a RAID array that is heavily used?
>> (d) what kind of errors should I see regarding "read errors" that
>> *would* indicate an imminent hardware failure?
>
> (a) these errors usually come from defective disk sectors. raid recos=
tructs
> the missing sector from parity from other disks in the array, then re=
writes
> the sector on the defective disk; if the sector is rewritten without =
error
> (maybe the hd remaps the sector into its reserved area), then just th=
e log
> messages is displayed.
>
> (b) with raid-6 it's almost benign; to get troubles you should get a =
read
> error on same sector for >2 disks; or have 2 disks failed and out of =
the
> array and get a read error on one of the other disks while recostruct=
ing the
> array; or have 1 disk failed and get a read error on same sector on >=
1 disk
> while recostructing (with raid-5 it's almost dangerous instead, as yo=
u can
> have big troubles if a disk fails and you get a read error on another=
 disk
> while recostructing; that happened to me!)
>
> (c) no; it's also a good rule to perform a periodic scrub of the arra=
y
> (check of the array), to reveal and correct defective sectors
>
> (d) check smart status of the disks, for "relocated sectors count"; a=
lso if
> md superblock is >=3D 1 there is a persistent count of corrected read=
 errors
> for each device into /sys/block/mdXX/md/dev-XX/errors, when this coun=
ter
> reaches 256 the disk is marked failed; ihmo when a disk is giving eve=
n few
> corrected read errors in a short interval its better to replace it.

Good call.

Here's the output of the reallocated sector count:

~ # for i in a b c d ; do smartctl -a /dev/sd$i | grep Realloc ; done
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       1
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       3
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       5
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       1

Are these values high? Low? Acceptable?

How about values like "Raw_Read_Error_Rate" and "Seek_Error_Rate" -- I
believe I've read those are values that are normally very high...is
this true?

~ # for i in a b c d ; do smartctl -a /dev/sd$i | grep
Raw_Read_Error_Rate ; done
  1 Raw_Read_Error_Rate     0x000f   116   099   006    Pre-fail
Always       -       106523474
  1 Raw_Read_Error_Rate     0x000f   114   099   006    Pre-fail
Always       -       77952706
  1 Raw_Read_Error_Rate     0x000f   117   099   006    Pre-fail
Always       -       137525325
  1 Raw_Read_Error_Rate     0x000f   118   099   006    Pre-fail
Always       -       179042738

=2E..and...

 ~ # for i in a b c d ; do smartctl -a /dev/sd$i | grep
Seek_Error_Rate ; done
  7 Seek_Error_Rate         0x000f   072   060   030    Pre-fail
Always       -       14923821
  7 Seek_Error_Rate         0x000f   072   060   030    Pre-fail
Always       -       15648709
  7 Seek_Error_Rate         0x000f   072   060   030    Pre-fail
Always       -       15733727
  7 Seek_Error_Rate         0x000f   071   060   030    Pre-fail
Always       -       14279452

Thoughts appreciated.

> --
> Yours faithfully.
>
> Giovanni Tessore
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
