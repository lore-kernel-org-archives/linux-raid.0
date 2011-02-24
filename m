From: Lasse Jensen <fafler@gmail.com>
Subject: Re: Assembling RAID 5 array with missing superblock
Date: Thu, 24 Feb 2011 09:17:56 +0100
Message-ID: <AANLkTimOB-kOW8Stw6w9rQu9aP8Fmz-nPmEn8w8m5y2H@mail.gmail.com>
References: <AANLkTinfMUaLOVHBh0ZXFmHs353u==XkbGYtM8MPNkh8@mail.gmail.com>
	<AANLkTikDCd1NiXzv28_KiGa8OmpmeWFRKoeZMfj_JdiD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikDCd1NiXzv28_KiGa8OmpmeWFRKoeZMfj_JdiD@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 24, 2011 at 5:45 AM,  <hansbkk@gmail.com> wrote:
> On Wed, Feb 23, 2011 at 9:05 PM, Lasse Jensen <fafler@gmail.com> wrote:
>> What drives are by the way the best consumer grade drives to use for
>> RAID operation?
>
> I've had good luck with Hitachi (used to be IBM) and Samsung lately,
> more so than WD. Hitachi's 5-year warranty (everyone else here being
> only 3) is also an indicator. . .

I used IBM back when they made the infamous DeathStar drives. Havent
brought a IBM/Hitachi drive since. I guess i'm going to feel the same
way about WD drives now. Maybe i should just mix'n'match manufactures.
They can't all be that bad,

> I know Google uses consumer-grade drives (with massive redundancy and
> automated hyper-vigilant sysadmin processes) - anyone know whose?
>
>
>> I just keep having bad luck with my RAID 5 array. One drive (out of 4
>> WD15EARS drives) was dropped from the array due to powerfailure and
>> rebuild failed because of bad sectors on another drive. I have been
>
> Sorry I can't help more but with any such large drives I'd suggest
> sticking with RAID6, plus hot spares if you think you might not notice
> and/or be able to quickly replace a failing member.

That was my plan, but without the hotspare. I have 2 drives i need to
get replaced, and after i hopefully regain access to my data, i'm
going for a 5 drive RAID 6 array.

-- 
Lasse Jensen (fafler at gmail dot com)
