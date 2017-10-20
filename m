From: Phil Turmel <philip@turmel.org>
Subject: Re: ***UNCHECKED*** Re: 3-disk RAID5 won't assemble
Date: Fri, 20 Oct 2017 19:49:43 -0400
Message-ID: <e1ef35a5-220f-bef5-6bc9-0b2108ebe630@turmel.org>
References: <03ddf14a-845d-a6a6-714d-e4bacb77dd7a@ieee.org>
 <59EA5DDB.2020400@youngman.org.uk>
 <9323bcbf-17ba-00d8-159a-38563562d472@ieee.org>
 <8a8ffdc8-4bad-4d99-2fc4-5457556f40f7@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8a8ffdc8-4bad-4d99-2fc4-5457556f40f7@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, Alex Elder <elder@ieee.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/20/2017 07:37 PM, Anthony Youngman wrote:
> On 20/10/17 23:46, Alex Elder wrote:

>> I would really appreciate having someone who's been through this
>> before glance through the mdadm, mdstat, and smartctl output I've
>> provided to make sure I'm not mistaken about the state of things.
>> Setting up the RAID was fine; but now that I'm (finally) dealing
>> with my first failure I am a bit apprehensive.
>>
>> Thanks a lot for your response.
>>
> Failing to fix the timeouts is just asking for problems to strike -
> usually some way down the line. Make sure you set that script up to run
> every boot BEFORE you try and fix the array. Then, as I say, just force
> the two good drives and re-add the third. Your array will be back ...
> (and if you really need to re-assure yourself, try it out with overlays
> first).

I endorse this advice and concur with it's positive tone.  Your array
should be fine, Alex.

Buy NAS drives in the future, though.

Phil
