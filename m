From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Mon, 29 Aug 2011 08:51:01 +0100
Message-ID: <CADNH=7G=HFSinigdCtHbSV0iKMGB57CrgjA+Qde4xRAeW7FURQ@mail.gmail.com>
References: <4E5787A1.7080807@xunil.at>
	<20110826125653.GA13709@cthulhu.home.robinhill.me.uk>
	<4E57A4D5.3070004@xunil.at>
	<20110826140810.GB13709@cthulhu.home.robinhill.me.uk>
	<4E57BEBB.2000606@xunil.at>
	<4E5B396D.9020609@xunil.at>
	<4E5B438D.8000107@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5B438D.8000107@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, robin.hill47@ntlworld.com
List-Id: linux-raid.ids

On 29 August 2011 08:45, Stefan G. Weichinger <lists@xunil.at> wrote:
> Am 29.08.2011 09:02, schrieb Stefan G. Weichinger:
>> Am 26.08.2011 17:41, schrieb Stefan G. Weichinger:
>>
>>> Yep, also clear now.
>>> I wait with that ddrescue-stuff anyway.
>>
>> Could I somehow make the hdd re-map those 2 sectors?
>
> I now followed
>
> http://smartmontools.sourceforge.net/badblockhowto.html#lvm
>
> and afai see the two bad blocks are inside a LVM-LV which is not
> important at all!
>
> It is a 20 GB LV prepared for something the customer never really use=
d
> so I will mv away the test-data and remove the LV.
>
> Does this somehow help me to be able to maybe remap the bad blocks?
>
> Thanks, Stefan
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Maybe running badblocks on the sector range (or over the whole HDD,
but in non-read-write mode it takes quite a while longer) will do the
trick.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
