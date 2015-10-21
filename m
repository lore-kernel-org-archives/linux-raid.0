From: Phil Turmel <philip@turmel.org>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 21 Oct 2015 08:01:38 -0400
Message-ID: <56277EA2.2010509@turmel.org>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
 <87f5f235fc9d29f9e146d5431d3642cb@tantosonline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f5f235fc9d29f9e146d5431d3642cb@tantosonline.com>
Sender: linux-raid-owner@vger.kernel.org
To: andras@tantosonline.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good morning Andras,

On 10/20/2015 11:52 PM, andras@tantosonline.com wrote:
> Phil,
> 
> Thank you so much for the detailed explanation and your patience with
> me! Sorry for not being more responsive - I don't have access to this
> mail account from work.

No worries.

>> for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done
>>
>> (Arrange for this to happen on every boot, and keep doing it manually
>> until your boot scripts are fixed.)
> 
> Yes, will do. In your links below it seems that you're half advocating
> for using desktop drives in RAID arrays, half advocating against. From
> what I can tell, it seems the recommendation might depend on the
> use-case. If one doesn't care too much about instant performance in case
> of errors, one might want to use desktop drivers (with the above fix).
> If one wants reliable performance, one probably wants NAS drives. Did I
> understand the basic trade-off correctly?

Times change.  At the time some of those were written, desktop drives
with scterc support were still available, but default off.  Those are ok
in a raid if you have the appropriate smartctl command in your boot scripts.

Long timeouts with non-scterc drives, in my opinion, create a user
impression that things are broken, even if the drive is fine (UREs are
natural and unavoidable in the life of a drive).  Users are prone to
drastic measures when they think something is broken.  Also,
*applications* might not wait that long for their read, either.  So, I
only recommend the long timeout solution when an array is already in
trouble with such drives.

> It seems that people also think that green drives are a bad idea in
> RAIDs in general - mostly because the frequent parking of heads reduces
> life-time. Is that a correct statement?

I don't have enough experience with green drives to say.  The few that I
have (bought before I discovered the dropped scterc support) became part
of my offsite backup rotation.

> Yes sir! I will go through the steps and report back. One question: the
> reason I shouldn't attempt to re-create the new 10-disk array is that it
> would wipe out the 7->10 grow progress, so MD would think that it's a
> fully grown 10-disk array, right?

Right.  Your three extra drives never really were incorporated into the
array, so the data layout is still a 7-drive pattern.

Phil
