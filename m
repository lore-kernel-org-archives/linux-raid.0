From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Mon, 11 Nov 2013 01:11:59 +0200
Message-ID: <73CFFCD7-1519-49A4-8817-5C1C1A85186F@gmail.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com> <527FCBAF.4070208@hardwarefreak.com> <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com> <527FDBC1.4000009@hardwarefreak.com> <20131111073428.583b83b2@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131111073428.583b83b2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stan@hardwarefreak.com, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 10, 2013, at 10:34 PM, NeilBrown <neilb@suse.de> wrote:

> On Sun, 10 Nov 2013 13:17:21 -0600 Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> 
>> Also, I see little/no value in running a scheduled mdadm check on a
>> RAID1 array.  Any problems with RAID1 will be due to one of the disks
>> beginning to fail in some mode, usually requiring sector relocation.
> 
> I think scrubbing has value on any RAID with redundancy.
> The firmware can only relocate a sector if it reads it when it is marginal
> but not yet completely lost.  If a sector is not read for a long time and
> during that time the media degraded beyond recovery the firmware cannot do
> anything.  But RAID1 can - it can get it from the other device.
> 
> NeilBrown

I think this is very relevant in my case. I typically offload a bulk of data to these drives, frequently using only some parts of it. So, it sounds like having check/scrubbing run on a schedule (how often is a reasonable frequency? every two weeks perhaps?) is a good idea after all.

Ivan