From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Multi-layer raid status
Date: Fri, 2 Feb 2018 13:12:11 +0100
Message-ID: <819a1736-8273-104d-d8e9-b340b887ca1a@thelounge.net>
References: <5A708F8E.2040604@hesbynett.no>
 <87372k2aix.fsf@notabene.neil.brown.name> <5A744054.4060305@hesbynett.no>
 <5A7448AF.3050108@youngman.org.uk> <5A744C4B.7030704@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A744C4B.7030704@hesbynett.no>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Wols Lists <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 02.02.2018 um 12:32 schrieb David Brown:
>> Okay, it would knacker performance a bit, but where you've got a nested
>> raid like this, you switch it on, run a read on the filesystem ( tar /
>> --no-follow > /dev/null sort of thing), and it would sort out integrity
>> all the way down the stack.
> 
> That's a scrub.  You do it as a very low priority task on a regular basis

if only that "low priority" would work these days....

dev.raid.speed_limit_min = 25000
dev.raid.speed_limit_max = 1000000

in the good old days "dev.raid.speed_limit_max" was how it is named and 
when you used your machine the scrub simply took longer, these days (for 
many months, few years) you better limit "dev.raid.speed_limit_max" and 
type "sysctl -p" and *after* that you can continue to use your machine
