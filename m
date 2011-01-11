From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: mdadm raid5 with lvm: advantages?
Date: Tue, 11 Jan 2011 16:40:18 -0200
Message-ID: <AANLkTi=WhBaw23oo8-0n5MyC9AY6_DS_piEBmo+bDeDJ@mail.gmail.com>
References: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
	<4D2CA32E.3030303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2CA32E.3030303@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: Richard Grundy <richguk@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

like email subject tell: advantages?

lvm suport - snapshots



2011/1/11 Zdenek Kaspar <zkaspar82@gmail.com>:
> Dne 11.1.2011 15:06, Richard Grundy napsal(a):
>> Hi,
>>
>> I'm building a new RAID5 array (of 5 1.5 TB drives) with mdadm and
>> would like to know the benefits of creating an LVM on top of this ar=
e
>> instead of just creating the filesystem on the md directly. I've nev=
er
>> had a problem growing the array and then resizing the filesystem
>> before and wondered if in this situation the only gain would be lvm
>> snapshot stuff? I'm planning to use ext4 for this array, if that mak=
es
>> any difference.
>>
>> Thanks in advanced,
>>
>> Rich
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> Really depends on your needs..
>
> It makes sense to use LVM for virtualization and iSCSI to get rid of =
big
> file images (unwanted fs overhead/fragmentation). But yes, in some us=
e
> cases this is OK.
>
> If you don't need snapshots or whatever LVM feature, then go the
> simplest way - no LVM.
>
> HTH, Z.
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
