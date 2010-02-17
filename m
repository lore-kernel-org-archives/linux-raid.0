From: david@lang.hm
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 09:41:53 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
References: <201002140251.59668.volkerarmin@googlemail.com>  <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>  <201002141940.35716.volkerarmin@googlemail.com> <4B7AD35E.7000405@tmr.com>  <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
  <20100217130103.3ca65ef3@notabene.brown> <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>  <4B7BB927.5000305@grumpydevil.homelinux.org> <f73f7ab81002170822j7e61455o6bee33d95c9648a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-721633254-1266428513=:4721"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f73f7ab81002170822j7e61455o6bee33d95c9648a1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-721633254-1266428513=:4721
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 17 Feb 2010, Kyle Moffett wrote:

> On Wed, Feb 17, 2010 at 04:38, Rudy Zijlstra
> <rudy@grumpydevil.homelinux.org> wrote:
>> Kyle Moffett wrote:
>>> On Tue, Feb 16, 2010 at 21:01, Neil Brown <neilb@suse.de> wrote:
>>>> I will not be removing 0.90 or auto-assemble from the kernel in the
>>>> foreseeable future.
>>>> None the less, I recommend weaning yourself from your dependence on it.
>>>> initramfs is the future, embrace it.
>>>>
>>>
>>> What are people's reasons for pushback against initramfs?  I've heard
>>> lots of claims that "it's not trustworthy" and "it breaks", but in 7
>>> years of running bootable software RAID boxes on weird architectures
>>> (even running Debian unstable) I have only once or twice had initramfs
>>> problems.

Kyle,
   for a distro that is trying to make one kernel image run on every 
possible type of hardware features like initramfs (and udev, modeules, 
etc) are wonderful.

however for people who run systems that are known ahead of time and 
static (and who build their own kernels instead of just relying on the 
distro default kernel), all of this is unnessesary complication, which 
leaves more room for problems to creep in.

David Lang
--680960-721633254-1266428513=:4721--
