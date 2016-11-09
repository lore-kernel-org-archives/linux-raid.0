From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Wed, 9 Nov 2016 13:00:03 -0600
Message-ID: <ff119b2a-bc7d-e0bc-0831-29e11e17f68c@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
 <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
 <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
 <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
 <57EAA214.8030603@youngman.org.uk>
 <5427ce35-f222-8a2c-486e-441c4c6ec9a6@gmail.com>
 <be044941-8097-7d6f-5216-294fe2cac4d9@websitemanagers.com.au>
 <0f6bd6f6-20ee-1720-23fc-27d206063bfc@gmail.com>
 <287df6d6-3850-1142-5c69-c7b54a8a22d4@gmail.com>
 <1497737a-a307-4501-4158-9703a051ef67@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1497737a-a307-4501-4158-9703a051ef67@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/08/2016 02:38 PM, Phil Turmel wrote:
> On 11/08/2016 02:53 PM, Benjammin2068 wrote:
>> On 11/08/2016 12:47 PM, Benjammin2068 wrote:
>> Now that I think about it -- and have been talking out loud to myself (I don't think I'm crazy)...
>>
>> A parallel to all this is:
>>
>> I don't think the mismatch_cnt started showing up until I moved from RAID5 to RAID6.
>>
>> :O
>>
>> How painful is it to switch back to RAID5 to test that theory?
> Don't.  Sounds like raid6's stricter calculations are catching a real problem.

Ok -- no switching back to RAID5.

> Do you have ECC RAM?

Yes.
>
> If so, are you getting any machine check exceptions?

not getting any machine check problems (I looked)

> If not, have you done a thorough memtest any time in the recent past?

Yes. When I started getting the mismatch counts, I took the system down and ran MEMtest on this through a couple of passes.

no problem.

> If it's not memory, can you exercise the controller channels heavily to
> see if they drop from errors?

I could but haven't -- any recommendations on tools out there?

Also, I've also wondered if the raid-check that happens on Sunday isn't actually part of that kind of problem.

i.e. if I didn't do the weekly check, the drives don't get slammed anywhere  near as much the rest of the week.

Does mismatch_cnt only change value during a check -- or does it happen with each operation?

> Have you added up the peak current draws of your drives to make sure
> your power supply keeps up when all drives are writing simultaneously
> (common with parity raid)?

Not exactly. but can do that. The system has a 650W supply -- I'll go do a power check and work that against the known drives in the system.

This is a "server chassis" though which came with the 8 slots in the front to power drives - so it's not exactly a "home chassis" that I put in a 300W and then jammed full of drives.

Still -- that's a reasonable question and I'll investigate.

> One more: do you have swap on top of md raid?

No. I've seen about mismatch on RAID1 causing mismatch counts.

However, I am running a VM on this RAID volume (VirtualBox and a reasonably sleepy instance of Win7_64) and have pondered that.


 -Ben


