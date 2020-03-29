From: Matt Wallis <mattw@madmonks.org>
Subject: Re: Requesting help repairing a RAID-6 array
Date: Mon, 30 Mar 2020 09:51:16 +1100
Message-ID: <3F145B73-B356-49DC-9DBC-559A650EAD65@madmonks.org>
References: <etPan.5e80defb.10afc736.32ba@crowston.name>
 <fc847f59-b221-c97c-28d6-813f8d79f15f@youngman.org.uk>
 <20200330033539.6171d8a5@natsu>
 <34bdb153-b2fc-9fd6-f48f-95bbacfe7149@youngman.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.19\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <34bdb153-b2fc-9fd6-f48f-95bbacfe7149@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>
Cc: Roman Mamedov <rm@romanrm.net>, "crowston.name" <kevin@crowston.name>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 30 Mar 2020, at 09:40, antlists <antlists@youngman.org.uk> wrote:
> 
> On 29/03/2020 23:35, Roman Mamedov wrote:
>> On Sun, 29 Mar 2020 23:31:35 +0100
>> antlists <antlists@youngman.org.uk> wrote:
>>> On 29/03/2020 18:45, crowston.name wrote:
>>>> === START OF INFORMATION SECTION ===
>>>> Device Model:     ST3000DM001-1CH166
>>>> Serial Number:    Z1F50Y21
>>>> Firmware Version: CC29
>>> 
>>> Seagate Barracuda :-( Not suitable as a raid drive.
>> Not suitable as a ...drive.
>> That model is literally the only hard drive in the world to get its own
>> Wikipedia article[1] for its awful reliability.
> Well, I've got two of them, and they've been very reliable. Bear in mind that that batch was just after the floods that disrupted production, I suspect that quality slipped because demand was excessive. Later production seems to have been fine. Barracudas generally are just crap for raid.


I had 4 of them in an array, they are what made me decide that RAID5 was no longer a viable RAID level, two of them failed, within an hour of each other.

Even a hot spare would not have recovered in that time.

Matt.
