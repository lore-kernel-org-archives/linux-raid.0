From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: filesystem on mdadm raid from unpartioned block devices
Date: Wed, 12 Jan 2011 20:39:02 -0200
Message-ID: <AANLkTikfX4-wQA7zCeuXOEmrz04Za+2Bp+3vqku9-sWA@mail.gmail.com>
References: <1294871497.16201.9.camel@TRAVLOR>
	<AANLkTik0V_c_+xjMgn6-qYbUd7o2C5w6csJ8UgLU5B7S@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik0V_c_+xjMgn6-qYbUd7o2C5w6csJ8UgLU5B7S@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: GarBoge <garboge@shaw.ca>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

options for raid in mkfs.ext4:


                   stride=3Dstride-size
                          Configure  the  filesystem  for  a  RAID  arr=
ay with
                          stride-size filesystem blocks. This is the nu=
mber of
                          blocks  read or written to disk before moving=
 to the
                          next disk, which is sometimes  referred  to  =
as  the
                          chunk   size.   This  mostly  affects  placem=
ent  of
                          filesystem metadata like bitmaps at mke2fs  t=
ime  to
                          avoid  placing them on a single disk, which c=
an hurt
                          performance.  It may also be used by the bloc=
k allo-
                          cator.



                   stripe-width=3Dstripe-width
                          Configure  the  filesystem  for  a  RAID  arr=
ay with
                          stripe-width filesystem blocks per stripe.  T=
his  is
                          typically  stride-size * N, where N is the nu=
mber of
                          data-bearing disks in the  RAID  (e.g.  for  =
RAID  5
                          there is one parity disk, so N will be the nu=
mber of
                          disks in the array minus 1).  This allows the=
  block
                          allocator to prevent read-modify-write of the=
 parity
                          in a RAID stripe if possible when the data is=
  writ-
                          ten.


i don=B4t know if it work


2011/1/12 Roberto Spadim <roberto@spadim.com.br>:
> i think that mkfs.ext4 is 4096 default block size
> -b 4096 is the option for device block size
>
>
> 2011/1/12 GarBoge <garboge@shaw.ca>:
>> A quick question that I haven't been able to find and answer for.
>>
>> I have been using whole block devices (whole unpartitioned hard driv=
es)
>> in various raid 1 and 5 setups using mdadm 3.1.4 with pretty mundane
>> options (default options such as striping and but using metadata 1.2=
).
>> Typically I use mkfs.ext4 with no options (default) to install the
>> filesystem.
>>
>> Is there an issue with alignment on the newer 4096-byte drives. If s=
o
>> what would be the proper approach?
>>
>> I thank you for your time.
>>
>> Ashley
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
