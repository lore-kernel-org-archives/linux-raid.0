From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Sun, 10 Nov 2013 16:36:35 -0600
Message-ID: <52800A73.9020401@hardwarefreak.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com>	<527FCBAF.4070208@hardwarefreak.com>	<58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com>	<527FDBC1.4000009@hardwarefreak.com> <20131111073428.583b83b2@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131111073428.583b83b2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/2013 2:34 PM, NeilBrown wrote:
> On Sun, 10 Nov 2013 13:17:21 -0600 Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> 
>> Also, I see little/no value in running a scheduled mdadm check on a
>> RAID1 array.  Any problems with RAID1 will be due to one of the disks
>> beginning to fail in some mode, usually requiring sector relocation.
> 
> I think scrubbing has value on any RAID with redundancy.

That's a bit... redundant, Neil. :)

> The firmware can only relocate a sector if it reads it when it is marginal
> but not yet completely lost.  If a sector is not read for a long time and
> during that time the media degraded beyond recovery the firmware cannot do
> anything.  But RAID1 can - it can get it from the other device.

But is a scrub required for this?  Isn't this exactly what occurs during
normal operation with md/RAID1?  I.e. a read fails with disk error, so
we grab the sector from the mirror?  So what advantage is there to
scrubbing md/RAID1?

-- 
Stan
