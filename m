From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 dead on the water after Controller failure
Date: Sat, 15 Feb 2014 22:49:14 -0500
Message-ID: <5300353A.8060509@turmel.org>
References: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com> <52FE7E2D.8020308@turmel.org> <5269CCC7-A0A7-479E-9738-88C74CB19435@gmail.com> <52FF83F1.3030904@turmel.org> <CAKuK5J0jxUUvkAY-U2Q6v5j9hf_nasOQOjvFGe+ThYaDFRt7yA@mail.gmail.com> <alpine.DEB.2.02.1402160001340.14422@uplift.swm.pp.se> <CAKuK5J3ry9SQPPJ_xGktZJFtoPQw1R+tE6eeRX7s6yTt+M79Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKuK5J3ry9SQPPJ_xGktZJFtoPQw1R+tE6eeRX7s6yTt+M79Zw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Florian Lampel <florian.lampel@gmail.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/15/2014 06:23 PM, Jon Nelson wrote:
> On Sat, Feb 15, 2014 at 5:04 PM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>> On Sat, 15 Feb 2014, Jon Nelson wrote:
>>
>>> Out of 12 drives, I thought RAID6 only offered a total of *2* failed
>>> devices. It seems to me that you have 7 devices in sync and 4 *almost* in
>>> sync. It's this "almost" part that has me confused. How can the raid run if
>>> the event count doesn't match? Wouldn't at least 10 out of 12 drives have to
>>> have the same event count to avoid data loss?
>>
>>
>> Correct. When you use --assemble --force you're basically telling mdadm "I
>> know what I'm doing and I'll take the risk of data loss or corruption". If
>> you assemble in with a kicked drive that was kicked long ago that has a
>> really far off event count, you can really really screw things up.
>>
>> Unless you use --force, mdadm won't assemble an array where the event count
>> doesn't match up.
> 
> Aha. So if you ran a check in this case, it would find some number of
> blocks that don't match up. What does MD do in that case?

Nothing other than reporting it in the mismatch_cnt.  If you then
perform a "repair" scrub, it will regenerate P&Q from the data blocks,
period.

If you think about it, five of the seven events are easily explained:
four dropped drives, plus cancellation of the rebuild onto what was then
/dev/sdh1.  So the opportunity for other corruption was small.  This is
precisely the scenario where forced assembly makes sense.  The drives
were failed for reasons other than actual drive failure.  The use of
--force tells mdadm that those drives aren't really bad.  But I left out
the partially rebuilt drive because it really couldn't be trusted.

HTH,

Phil


