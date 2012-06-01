From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Fri, 1 Jun 2012 23:19:00 +0800
Message-ID: <CA+sTkh6ScqXKcnDZemQBjNhJ1oQb7VSFP0_bjsU08ZJ5GY4j-A@mail.gmail.com>
References: <20120531083158.GE3867@bitfolk.com> <4FC81B85.8090807@hardwarefreak.com>
 <CA+sTkh4+MKYaXwYe13F6Gy4VZbT0bXZpC79Bgcn1a3ZSzqwq8A@mail.gmail.com> <4FC8CDE1.4050807@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC8CDE1.4050807@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1 June 2012 22:12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 5/31/2012 10:15 PM, Igor M Podlesny wrote:
>> On 1 June 2012 09:31, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> [=E2=80=A6]
>>> You could probably expect it to be more reliable if you used RAID a=
s
>>> it's meant to be used, which in this case would be a single RAID10 =
array
>>> using none, or only one partition per disk, instead of creating 4 o=
r 5
>>> different md RAID arrays from 4-5 partitions on each disk. =C2=A0Th=
is is
>>> simply silly, and it's dangerous if doing so inside VMs.
>>
>> =C2=A0 =C2=A0=E2=80=94 How do you know those RAIDs are inside VMs?
>
> Those who speak English as a first language likely understood my use =
of

   So you don't. Well, lemme remind some words of wisdom to you:
"Assumption is the mother of all f*ckups". (Feel free to reverse it as
you like), Stan.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
