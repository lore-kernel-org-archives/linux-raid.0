From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Mon, 29 Aug 2011 10:25:54 +0200
Message-ID: <4E5B4D12.5060604@xunil.at>
References: <4E5787A1.7080807@xunil.at> <20110826125653.GA13709@cthulhu.home.robinhill.me.uk> <4E57A4D5.3070004@xunil.at> <20110826140810.GB13709@cthulhu.home.robinhill.me.uk> <4E57BEBB.2000606@xunil.at> <4E5B396D.9020609@xunil.at> <4E5B438D.8000107@xunil.at> <CADNH=7G=HFSinigdCtHbSV0iKMGB57CrgjA+Qde4xRAeW7FURQ@mail.gmail.com> <4E5B4712.90106@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5B4712.90106@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, robin.hill47@ntlworld.com
List-Id: linux-raid.ids

Am 29.08.2011 10:00, schrieb Stefan G. Weichinger:
> Am 29.08.2011 09:51, schrieb Mathias Bur=C3=A9n:
>=20
>> Maybe running badblocks on the sector range (or over the whole HDD,
>> but in non-read-write mode it takes quite a while longer) will do th=
e
>> trick.
>=20
> I currently run "badblocks -n -s /dev/VG01/my_lv" ... we'll see

Switched over to

dd if=3D/dev/zero of=3D/dev/VG01/my_lv bs=3D4096

This executed without error (wrote ~20GB) and now when I check with:

smartctl -a /dev/sda

I get

197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s
      -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0


Sounds good to me! Right?

So now I could re-add /dev/sdb4 to retry syncing that array, correct?

Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
