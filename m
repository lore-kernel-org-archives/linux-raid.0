From: Phil Turmel <philip@turmel.org>
Subject: Re: Cannot start array on disk
Date: Wed, 20 Jul 2016 06:30:30 -0400
Message-ID: <6b958d9f-ec61-3b87-fcd7-ff63c0af32fe@turmel.org>
References: <1124605843.526681.1468785592654.JavaMail.yahoo.ref@mail.yahoo.com>
 <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com>
 <73583e52-ca6b-b043-cbae-02c8a122be24@turmel.org>
 <1436537429.1672198.1468980612541.JavaMail.yahoo@mail.yahoo.com>
 <1537154003.1687848.1468983169996.JavaMail.yahoo@mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1537154003.1687848.1468983169996.JavaMail.yahoo@mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bhatia Amit <amitbhatia@rocketmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Amit,

{ Note, convention on kernel.org is to trim & bottom post, or interleave
replies with trimmed context. }

On 07/19/2016 10:52 PM, Bhatia Amit wrote:
> Hi Phil
> 
> One more thing. When the enclosure became inaccesible in June 2016,
> WDC gave me a new unit with drives. I dont remember for sure, but I
> think I first replaced drive A from new enclosure with the Drive A
> (currently in discussion) from old enclosure, hoping new unit would
> reconfigure based on info from old drive. But I was not able to
> access the unit. Then I put back the two new drives back in new
> enclosure, configured new unit for RAID1 and then replaced the drive
> A again with the drive A from old enclosure, but again no luck
> accessing it (Error Message=Unable to mount). Since the default
> configuration of a new configuration is Striping and not RAID1,
> probably the first action (replacing drive A before configuring new
> unit for RAID1), might have been the cause why this drive A shows as
> RAID=linear, rather than RAID1.

That could explain it, but I would have expected your mount of /dev/sdc4
to succeed.  Your dmesg excerpt clearly shows a raid1 binding on
partition 4, so the metadata on the drive you are examining must be
wrong.  The only way I know for that to happen is if there are multiple
superblocks on the drive, and a plain examine is finding the v1.0
metadata first.

I'm not sure if this is supported, by try specifying the version along
with --examine for each of v0.90, v1.0, v1.1, and v1.2 to see if any
difference shows.  Paste the results from each.

Phil
