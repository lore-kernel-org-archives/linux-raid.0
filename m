From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Sun, 10 Nov 2013 20:08:02 -0600
Message-ID: <52803C02.1010201@hardwarefreak.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com>	<527FCBAF.4070208@hardwarefreak.com>	<58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com>	<527FDBC1.4000009@hardwarefreak.com> <20131111073428.583b83b2@notabene.brown> <52800A73.9020401@hardwarefreak.com> <52800E98.3080105@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52800E98.3080105@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/2013 4:54 PM, Adam Goryachev wrote:
> On 11/11/13 09:36, Stan Hoeppner wrote:
>> On 11/10/2013 2:34 PM, NeilBrown wrote:
>>> The firmware can only relocate a sector if it reads it when it is
>>> marginal
>>> but not yet completely lost.  If a sector is not read for a long time
>>> and
>>> during that time the media degraded beyond recovery the firmware
>>> cannot do
>>> anything.  But RAID1 can - it can get it from the other device.
>> But is a scrub required for this?  Isn't this exactly what occurs during
>> normal operation with md/RAID1?  I.e. a read fails with disk error, so
>> we grab the sector from the mirror?  So what advantage is there to
>> scrubbing md/RAID1?
> Wouldn't a check of the raid cause each member to be read in full,
> therefore helping the disk to notice that the sector is marginal, and/or
> the RAID layer to notice that the sector is no longer readable and
> therefore read from the other member, and re-write the sector. Consider
> a sector that is very rarely accessed...
> 
> Or are you suggesting that a smart command issued to the underlying
> devices can solve both of those scenarios?

No, what I suggest is that drive instrumentation will often alert one to
drive problems before you see a read error at the kernel.  Assuming this
is true then scrubbing isn't necessary.

What Neil describes is a case where a sector is written once and read
very infrequently, or possibly years after the write, i.e. long term
archiving.  In this case a scrub may discover a media defect which may
go unnoticed by the drive firmware or normal md array operation.

-- 
Stan
