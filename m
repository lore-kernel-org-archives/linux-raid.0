From: hansbkk@gmail.com
Subject: Re: [linux-lvm] Q: LVM over RAID, or plain disks? A:"Yes" = best of
 both worlds?
Date: Wed, 1 Dec 2010 11:45:30 +0700
Message-ID: <AANLkTin4f=W69mr923KhSYT_qvFnLiz0fpScWo0w1rfu@mail.gmail.com>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
	<AANLkTimGkMJGiJC+7L+Pu3+yf-J_s0Ex3hM2-g-0+UqQ@mail.gmail.com>
	<4CF3F7A0.2080108@rjl.com>
	<AANLkTim67atrgHEzunBRvp4ij+MUDiTg4vu5t6sbgFLq@mail.gmail.com>
	<4CF4A472.20107@rjl.com>
	<AANLkTing5ApAXM2o0M+pxNvg01mHewNgGGBiUXM3aLzZ@mail.gmail.com>
	<4CF4F85C.1020806@turmel.org>
	<AANLkTi=F5Ttrp9-_wto4ZNWiDvY=cPe0_p26BPyzvMDz@mail.gmail.com>
	<4CF52CA5.1090405@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF52CA5.1090405@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On Tue, Nov 30, 2010 at 11:56 PM, Phil Turmel <philip@turmel.org> wrote=
:

> (Actually, rsync and tar are both hardlink-aware, at least the versio=
ns I use.)

My backup filesystems contain so many hardlinks (millions, constantly
growing) that file-level tools choke - this really must be done at the
block device level - see my previous post for more detail.

It's also now clear to me that rsync is the tool to use for this for
all the other LVs without such problematic filesystems, as I know the
tool and trust its error-checking routines.


>> So adapting your suggestion to fit (my perception of) my needs:
>>
>> =A0 - create an LV snapshot
>> =A0 - mount a plain partition on a physical hard disk (preferably on=
 a
>> separate controller?)
>> =A0 - dd the data from the LV snapshot over to the partition
>> =A0 - delete the snapshot
>
> Yep, this is basically what I recommended.

>> So I guess my question becomes:
>>
>> What is the best tool to block-level clone an LV snapshot to a regul=
ar
>> disk partition?
>>
>> =A0 - "best" =3D as close to 100% reliably as possible, speed isn't =
nearly
>> as important
>
> I would use dd.

OK, that's clear, thanks.


>> Would a COT cloning package (something like Acronis TrueImage) have
>> data reliability advantages (like mdm's) over dd?
>
> Not really. =A0But they may offer various forms of compression/sparsi=
fication/error detection if you wish to store the final backups as file=
s. =A0Of course, if you do that, you might as well use tar+gzip+md5sum.

No, I'm talking about partition-to-partition cloning operations, which
some of these do support. The error detection is critical, and why I
was looking at mdraid in the first place.


> You want your dismountable disks to be accessible stand-alone, but I =
don't see why that would preclude setting them up so each is a unique L=
VM VG.

It doesn't preclude it, but it's a layer of complexity during the data
recovery process I'm trying to avoid.

The ultimate goal is a plain partition on a plain disk that can be
directly mounted on a SATA2 host via a normal recovery/LiveCD by a
user that's never heard of RAID or LVM.


To summarize your feedback:

  - mdraid's sync error-checking routines don't add value over dd to
ensure accurate cloning of a static partition; its metadata is just
useless overhead in this case.

  - dd is reliable enough

One last question (and I do realize it's now OT for here, so I won't
be hurt if it's ignored :)

Does dd already do some sort of "verify after copy"? I will likely
investigate the available COTS partition cloning tools as well.


Thanks for all your help, not least in helping me to clarify my own goa=
ls
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
