From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 23:41:00 +0000
Message-ID: <AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<iiud2r$qci$1@dough.gmane.org>
	<4D62ACFE.4020401@cfl.rr.com>
	<AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
	<AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>
	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>
	<AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>
	<4D62CF5F.6080007@cfl.rr.com>
	<AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>
	<AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21 February 2011 22:52, Roberto Spadim <roberto@spadim.com.br> wrote=
:
> i don=C2=B4t think so, since it=C2=B4s ATA command, any ATA compatibl=
e can use
> it, it could be used for HD with badblocks and dynamic reallocation
> without problems, the harddisk don=C2=B4t need a dedicated space for
> badblock. for md software we must know if devices support or not TRIM=
=2E
>
> the next question, md is ATA compatible? no!?, it=C2=B4s a linux devi=
ce,
> not a ATA device. what commands linux devices allow? could md allow
> TRIM?
>
> 2011/2/21 Mathias Bur=C3=A9n <mathias.buren@gmail.com>:
>> On 21 February 2011 20:47, Phillip Susi <psusi@cfl.rr.com> wrote:
>>> On 2/21/2011 2:39 PM, Roberto Spadim wrote:
>>>> sorry, but i sent email without a information:
>>>> TRIM is a 'ATA Specification' command
>>>>
>>>> http://en.wikipedia.org/wiki/TRIM_command
>>>>
>>>> any disk with ATA command could suport TRIM, hard disk or ssd or
>>>> anyother type of phisical allocation
>>>
>>> Sure, but hard disks have no reason to, which is why they don't and
>>> won't support it.
>>>
>>
>> My point exactly.
>>
>> // M
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>

Please don't top post.
http://www.splitbrain.org/blog/2011-02/15-top_posting_like_dont_i_why

Harddrives already have an allocated area with spare sectors, which
they use whenever they need to. You can find out how many sectors have
been reallocated by the HDD by looking at the SMART data, like so:

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
[...]
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0

// M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
