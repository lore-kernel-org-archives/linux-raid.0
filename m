From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: lib/raid6: SSSE3 optimized recovery functions v1
Date: Mon, 19 Mar 2012 23:00:19 +0000
Message-ID: <CADNH=7HV2UrkEb9J7dppMrwmy1264wmXgApmE+xKb6S=hdeq3A@mail.gmail.com>
References: <1332180649-9709-1-git-send-email-james.t.kukunas@linux.intel.com>
	<4F67B6BC.4070006@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F67B6BC.4070006@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 March 2012 22:44, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/19/2012 11:10 AM, Jim Kukunas wrote:
>> Hi Folks,
>>
>> The following patchset adds SSSE3 optimized recovery
>> functions to RAID6.
>>
>> This version differs from version 0, in that the build fix for the
>> test program was split into a separate patch.
>>
>> A technical description of the algorithm can be found
>> at http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
>>
>
> Reviewed-by: H. Peter Anvin <hpa@zytor.com>
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0-hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

Hi,

Interesting! I read the PDF but could not find any numbers. Have you
performed any benchmarks on RAID6 recovery on SSSE3 hardware with and
without your patch?

Best regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
