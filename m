From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: lib/raid6: SSSE3 optimized recovery functions v1
Date: Tue, 20 Mar 2012 00:03:15 +0000
Message-ID: <CADNH=7E2QRVxW875dbe+kMiL1cZJWR2BTEnXig1+72K+X+5WRA@mail.gmail.com>
References: <1332180649-9709-1-git-send-email-james.t.kukunas@linux.intel.com>
	<4F67B6BC.4070006@zytor.com>
	<CADNH=7HV2UrkEb9J7dppMrwmy1264wmXgApmE+xKb6S=hdeq3A@mail.gmail.com>
	<4F67BFD4.1070104@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F67BFD4.1070104@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 March 2012 23:23, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/19/2012 04:00 PM, Mathias Bur=C3=A9n wrote:
>>
>> Hi,
>>
>> Interesting! I read the PDF but could not find any numbers. Have you
>> performed any benchmarks on RAID6 recovery on SSSE3 hardware with an=
d
>> without your patch?
>>
>
> I ran some tests on the core algorithm and found it to be about 3x fa=
ster.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0-hpa
>

Great. I can't wait to try it on my Intel Atom (I just found out it
supports SSSE3).

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
