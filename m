From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Tue, 18 Jan 2011 15:22:04 -0200
Message-ID: <AANLkTik3ZEPLKM79ZPABqUrnAgxa8rgy0ecpNsdCT3g3@mail.gmail.com>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
	<4D35C9BB.20908@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D35C9BB.20908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: for.poige+linux@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maybe we could do betters read/write algorithm for devices (hard disks
/ solid state disks) for example (round robin, closer head, minimal
read/write time) that make a more optimized operation with mixed disks
array (ssd+hdd array) for raid 0,1,10,5,6,x+y

2011/1/18 John Robinson <john.robinson@anonymous.org.uk>:
> On 18/01/2011 15:59, Igor Podlesny wrote:
>>
>> =A0 =A0I had experience of using FreeBSD's vinum (another software R=
AID).
>> Its author, Greg Lehey, stated in vinum's manual: "... A good
>> guideline for stripe size is between 256 kB and 512 kB. =A0Avoid pow=
ers
>> of 2, however: they tend to cause all superblocks to be placed on th=
e
>> first subdisk. ..."
>>
>> =A0 =A0Meanwhile, with LSR we're given exactly 2^n choices, for e. g=
=2E,
>> neither 768 KiB, nor 387 KiB won't go: "mdadm: invalid chunk/roundin=
g
>> value: 387".
>>
>> =A0 =A0So, why... ($Subj) and how complex would it be to abolish thi=
s
>> restriction? I think this could be a key to performance increase.
>
> You're slightly confusing things. Stripe size and chunk size are diff=
erent
> things, but related. Stripe size =3D number of data discs * chunk siz=
e. Linux
> software RAID does insist on a power of two chunk size, which is almo=
st
> certainly done for performance reasons, but obviously it can't insist=
 on a
> power of two stripe size, e.g. a 3-disc RAID-0, 4-disc RAID-5 or 5-di=
sc
> RAID-6 would all have 3 data discs so the stripe size won't be a powe=
r of
> two.
>
> Secondly, as far as I know all Linux filesystems are RAID-aware so kn=
ow how
> to distribute their superblocks and other metadata evenly across all =
the
> discs, so they've already got any performance improvement that might =
be had.
>
> Cheers,
>
> John.
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
