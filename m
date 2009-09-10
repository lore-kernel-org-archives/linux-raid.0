From: "Majed B." <majedb@gmail.com>
Subject: Re: Raid5 Read Perf drop in 2.6.27
Date: Thu, 10 Sep 2009 12:37:19 +0300
Message-ID: <70ed7c3e0909100237ra4903edkb128555a6427632c@mail.gmail.com>
References: <f5d1f90a0909091554u6d40b402ga7e9f58cabf21b57@mail.gmail.com>
	<70ed7c3e0909091652m60b0ea9cp7000db919a639c35@mail.gmail.com>
	<f5d1f90a0909091817g667d211djcf767714740102d@mail.gmail.com>
	<70ed7c3e0909091827i745e2e38u6f8e246a0c9a49f@mail.gmail.com>
	<f5d1f90a0909091845t744ce5cerdf00fd656ff21c09@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909091845t744ce5cerdf00fd656ff21c09@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I did a quick test a few days back:
http://mbhtech.blogspot.com/2009/09/software-raid-vs-lvm-quick-speed-te=
st_08.html

That was run on an Ubuntu Server machine with running kernel:
2.6.28-15-server #49-Ubuntu SMP
Unfortunately I don't have access to the machine now, so I can't
attach the kernel's .config file.

On Thu, Sep 10, 2009 at 4:45 AM, Linux Raid
Study<linuxraid.study@gmail.com> wrote:
> I build/compile my own kernel..
>
> Have you done any benchmarks for Read RAID5 perf?
>
> Thanks!
>
> On 9/9/09, Majed B. <majedb@gmail.com> wrote:
>> Well, that's my point. To make sure that your kernels are identical =
in
>> =C2=A0options, compare the .config files found in /usr/src/linux-<ve=
rsion>
>>
>> =C2=A0You may find changes and differences in areas like bluetooth,
>> =C2=A0wireless, ...etc. These don't matter.
>>
>> =C2=A0Did you compile your own kernel, or are you using one compiled=
 for a
>> =C2=A0specific distro?
--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
