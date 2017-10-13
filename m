From: Phil Turmel <philip@turmel.org>
Subject: Re: INITRDSTART replacement
Date: Fri, 13 Oct 2017 14:03:45 -0400
Message-ID: <1950fb1c-874d-554d-4b57-be51d0d7bd7a@turmel.org>
References: <CADvHm=a3haC3xVKJ5QuOSftw5ttU=wJq2_bp8LJfMDVn1g6=Gg@mail.gmail.com>
 <CADvHm=YBEGs-wESbWbKpG_k=BUgL7odWJy79ahJCbwQ_mShtzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADvHm=YBEGs-wESbWbKpG_k=BUgL7odWJy79ahJCbwQ_mShtzA@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/13/2017 08:22 AM, Caspar Smit wrote:
> "I'm using debian Jessie"
> 
> Sorry, i meant Debian Stretch (9.2)

>> I've always used the INITRDSTART directive in the /etc/default/mdadm
>> config file to prevent any md from starting during the initram phase
>> of boot (INITRDSTART=none). Some disk controller drivers do not always
>> present their disks in time before the md_mod, raid1, etc.. drivers
>> are loaded, leaving you with a degraded assembled array. I do not need
>> to boot from an md device so i don't need the md drivers during the
>> initram phase.
>>
>> I noticed in the changelog that INITRDSTART support was dropped in
>> version 3.4-2 (I'm using debian Jessie)
>>
>> Is there any new method to prevent md's from starting in the initram
>> phase or am i doing something completely wrong here?

Just arrange to have your initramfs contain a different mdadm.conf file,
with a line showing AUTO=-all and no ARRAY statements.

This approach is quite flexible, as it allows an initramfs to assemble
one or more specific arrays (needed for boot) with ARRAY= while
leaving any non-critical arrays for post-initramfs.  In your case, all
of them.

Phil
