From: david@lang.hm
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 23:21:52 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1002132320320.5135@asgard.lang.hm>
References: <201002140251.59668.volkerarmin@googlemail.com> <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-1867897933-1266132112=:5135"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-1867897933-1266132112=:5135
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 13 Feb 2010, Michael Evans wrote:

> On Sat, Feb 13, 2010 at 5:51 PM, Volker Armin Hemmann
> <volkerarmin@googlemail.com> wrote:
>>> 0.90 has a very bad problem, which is that it is hard to distinguish
>>> between a RAID partition at the end of volume and a full RAID device.
>>> This is because 0.90 doesn't actually tell you the start of the device.
>>>
>>> Then, of course, there are a lot of limitations on size, number of
>>> devices, and so on in 0.90.
>>
>> but it is the only format supporting autodetection.
>>
>> So - when will autodetection be introduced with 1.X? And if not, why not?
>>
>> All I found was 'autodetection might be troublesome' and nothing else.
>>  But dealing with initrds is troublesome too. Pure evil even.
>>
>> Gl?ck Auf,
>> Volker
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> I remember hearing that 1.x had /no/ plans for kernel level
> auto-detection ever.  That can be accomplished in early-userspace
> leaving the code in the kernel much less complex, and therefore far
> more reliable.
>
> In other words, 'auto-detection' for 1.x format devices is using an
> initrd/initramfs.

hmm, I've used 1.x formats without an initrd/initramfs (and without any 
conifg file on the server) and have had no problem with them being 
discovered. I haven't tried to use one for a boot/root device, so that may 
be the difference.

David Lang
--680960-1867897933-1266132112=:5135--
