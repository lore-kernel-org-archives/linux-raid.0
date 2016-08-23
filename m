From: Chris Murphy <lists@colorremedies.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 23 Aug 2016 09:02:14 -0600
Message-ID: <CAJCQCtRkHstmmJXOd8pVbuZSQnH-RDnkePb1gkFT_Vt0kSsH-A@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-C7CMqUBe+kPaxxTtmvuCXSRes73kMcAnZw7x8=6DNCdw@mail.gmail.com>
 <CAFx4rwTawqrBOWVwtPnGhRRAM1XiGQkS-o3YykmD0AftR45YkA@mail.gmail.com> <CAJvUf-C8ov4tHRGj5SPamJE8PF0Qsr4Cwuv02-9F0SV1yp4ccQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-C8ov4tHRGj5SPamJE8PF0Qsr4Cwuv02-9F0SV1yp4ccQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 23, 2016 at 8:34 AM, Matt Garman <matthew.garman@gmail.com> wrote:
> On Tue, Aug 16, 2016 at 5:43 PM, Doug Dumitru <doug@easyco.com> wrote:
>> One last thing I would highly recommend is:
>>
>> Secure erase the replacement disk before rebuilding onto it.
>>
>> If the replacement disk is "pre conditioned" with random writes, even if
>> very slowly, this will lower the write performance of the disk during the
>> rebuild.
>
> Does that also apply to brand-new disks from the manufacturer?
>
> I.e., should we just always do a secure erase, or sometimes depending
> on how the drive was sourced?

The main issue is to get rid of previous fs signatures so there are no
longer stale file systems. If the drive is/was ever partitioned, those
signatures could be anywhere on the drive, so the ATA secure erase is
a way to clobber all of them. An alternative is fully encrypting the
drive. If you merely change the encryption key, cipher text on the
drive becomes different "cipher text" as it's decrypted, so again
everything that was on the drive is effectively obliterated, but is
much faster. If security isn't a big concern, you can automate opening
the LUKS device with a keyfile to avoid manually typing in
passphrases. The other nice thing about it is if you ever have to
return such a drive under warranty, or otherwise decommission it, you
don't have to worry about drive contents.

-- 
Chris Murphy
