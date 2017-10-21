From: Alex Elder <elder@ieee.org>
Subject: Re: ***UNCHECKED*** Re: 3-disk RAID5 won't assemble
Date: Fri, 20 Oct 2017 22:40:00 -0500
Message-ID: <7db1f2fc-3018-5a0a-89a1-74d6762df463@ieee.org>
References: <03ddf14a-845d-a6a6-714d-e4bacb77dd7a@ieee.org>
 <59EA5DDB.2020400@youngman.org.uk>
 <9323bcbf-17ba-00d8-159a-38563562d472@ieee.org>
 <8a8ffdc8-4bad-4d99-2fc4-5457556f40f7@youngman.org.uk>
 <e1ef35a5-220f-bef5-6bc9-0b2108ebe630@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e1ef35a5-220f-bef5-6bc9-0b2108ebe630@turmel.org>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/20/2017 06:49 PM, Phil Turmel wrote:
> On 10/20/2017 07:37 PM, Anthony Youngman wrote:
>> On 20/10/17 23:46, Alex Elder wrote:
> 
>>> I would really appreciate having someone who's been through this
>>> before glance through the mdadm, mdstat, and smartctl output I've
>>> provided to make sure I'm not mistaken about the state of things.
>>> Setting up the RAID was fine; but now that I'm (finally) dealing
>>> with my first failure I am a bit apprehensive.
>>>
>>> Thanks a lot for your response.
>>>
>> Failing to fix the timeouts is just asking for problems to strike -
>> usually some way down the line. Make sure you set that script up to run
>> every boot BEFORE you try and fix the array. Then, as I say, just force
>> the two good drives and re-add the third. Your array will be back ...
>> (and if you really need to re-assure yourself, try it out with overlays
>> first).
> 
> I endorse this advice and concur with it's positive tone.  Your array
> should be fine, Alex.

You guys are really great.  I am back running again.  Thank you
for taking the time to help me out.  It saved me a LOT of time
trying to chase down what I needed to do, and most importantly
you gave me the confidence to proceed with only a modest level
of anxiety...  The hardest thing was creating a new systemd
service to run the script at boot time (also a first for me).

> Buy NAS drives in the future, though.

Hey, they were never going to fail!  RAID solves all problems.

But yeah, I'll look more closely at that next time.

Thanks again.

					-Alex

> Phil
> 

