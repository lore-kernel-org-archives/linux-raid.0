From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Fri, 26 Aug 2011 21:00:23 +0100
Message-ID: <CADNH=7E0GEdnPSBJdwQx3kSwZzzz9mOaHqvjLfG+AJz3ts+zNQ@mail.gmail.com>
References: <4E5787A1.7080807@xunil.at>
	<CADNH=7HMgJ9+wCEH5i03L6UmQw2xnMopnx09z8W0nU-q6_0Dig@mail.gmail.com>
	<4E578F4D.9050908@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E578F4D.9050908@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26 August 2011 13:19, Stefan G. Weichinger <lists@xunil.at> wrote:
> Am 26.08.2011 14:01, schrieb Mathias Bur=C3=A9n:
>
>> Could you perhaps post the output of "smartctl -a /dev/sda" (and sdb
>> for completeness sake) here? You can find smartctl in the
>> smartmontools package.
>
> sure. sdb is the new hdd from today (as mentioned)
>
> ->
>
(snip)
>
>

=46WIW, sda is failing, looking at uncorrectable sectors and all else.
If possible I'd mount the HDD (array) read-only, copy the contents
somewhere else, then recreate the array from scratch using your new
HDD and a new HDD to replace sda.

/Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
