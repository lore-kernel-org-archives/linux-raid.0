From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Fri, 01 Jun 2012 09:12:49 -0500
Message-ID: <4FC8CDE1.4050807@hardwarefreak.com>
References: <20120531083158.GE3867@bitfolk.com> <4FC81B85.8090807@hardwarefreak.com> <CA+sTkh4+MKYaXwYe13F6Gy4VZbT0bXZpC79Bgcn1a3ZSzqwq8A@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh4+MKYaXwYe13F6Gy4VZbT0bXZpC79Bgcn1a3ZSzqwq8A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/31/2012 10:15 PM, Igor M Podlesny wrote:
> On 1 June 2012 09:31, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> [=85]
>> You could probably expect it to be more reliable if you used RAID as
>> it's meant to be used, which in this case would be a single RAID10 a=
rray
>> using none, or only one partition per disk, instead of creating 4 or=
 5
>> different md RAID arrays from 4-5 partitions on each disk.  This is
>> simply silly, and it's dangerous if doing so inside VMs.
>=20
>    =97 How do you know those RAIDs are inside VMs?

Those who speak English as a first language likely understood my use of
"if".  Had I used "when" instead, that would have implied certainty of
knowledge.  "If" conveys a possibility, a hypothetical.

=46or the English challenged, maybe reversing the sentence is more
comprehensible:

"If doing so inside VMs it is dangerous."

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
