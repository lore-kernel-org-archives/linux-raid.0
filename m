From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 00:38:58 -0800
Message-ID: <4877c76c1002140038p4a7d8d75r3bc9d615b0e68199@mail.gmail.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
	 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
	 <alpine.DEB.2.00.1002132320320.5135@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1002132320320.5135@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 13, 2010 at 11:21 PM,  <david@lang.hm> wrote:
> On Sat, 13 Feb 2010, Michael Evans wrote:
>
>> On Sat, Feb 13, 2010 at 5:51 PM, Volker Armin Hemmann
>> <volkerarmin@googlemail.com> wrote:
>>>>
>>>> 0.90 has a very bad problem, which is that it is hard to distingui=
sh
>>>> between a RAID partition at the end of volume and a full RAID devi=
ce.
>>>> This is because 0.90 doesn't actually tell you the start of the de=
vice.
>>>>
>>>> Then, of course, there are a lot of limitations on size, number of
>>>> devices, and so on in 0.90.
>>>
>>> but it is the only format supporting autodetection.
>>>
>>> So - when will autodetection be introduced with 1.X? And if not, wh=
y not?
>>>
>>> All I found was 'autodetection might be troublesome' and nothing el=
se.
>>> =A0But dealing with initrds is troublesome too. Pure evil even.
>>>
>>> Gl?ck Auf,
>>> Volker
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>> I remember hearing that 1.x had /no/ plans for kernel level
>> auto-detection ever. =A0That can be accomplished in early-userspace
>> leaving the code in the kernel much less complex, and therefore far
>> more reliable.
>>
>> In other words, 'auto-detection' for 1.x format devices is using an
>> initrd/initramfs.
>
> hmm, I've used 1.x formats without an initrd/initramfs (and without a=
ny
> conifg file on the server) and have had no problem with them being
> discovered. I haven't tried to use one for a boot/root device, so tha=
t may
> be the difference.
>
> David Lang

Yes, that is the difference.  You must have a more traditional simple
block device and filesystem drivers compiled in.  You have no need for
extra drivers or higher level device detection and evaluation (with
user-set policies to determine operation).  Anything past root-fs
mount can happen in normal user-space before logins are enabled.
