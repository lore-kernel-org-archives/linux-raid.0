From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Mon, 29 Aug 2011 10:00:18 +0200
Message-ID: <4E5B4712.90106@xunil.at>
References: <4E5787A1.7080807@xunil.at> <20110826125653.GA13709@cthulhu.home.robinhill.me.uk> <4E57A4D5.3070004@xunil.at> <20110826140810.GB13709@cthulhu.home.robinhill.me.uk> <4E57BEBB.2000606@xunil.at> <4E5B396D.9020609@xunil.at> <4E5B438D.8000107@xunil.at> <CADNH=7G=HFSinigdCtHbSV0iKMGB57CrgjA+Qde4xRAeW7FURQ@mail.gmail.com>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7G=HFSinigdCtHbSV0iKMGB57CrgjA+Qde4xRAeW7FURQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, robin.hill47@ntlworld.com
List-Id: linux-raid.ids

Am 29.08.2011 09:51, schrieb Mathias Bur=C3=A9n:

> Maybe running badblocks on the sector range (or over the whole HDD,
> but in non-read-write mode it takes quite a while longer) will do the
> trick.

I currently run "badblocks -n -s /dev/VG01/my_lv" ... we'll see

S
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
