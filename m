From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 15:23:10 +0800
Message-ID: <4DDA0B5E.8060104@fnarfbargle.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <4DD99A16.5010108@fnarfbargle.com> <4DDA04BE.9000300@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDA04BE.9000300@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/11 14:54, Stan Hoeppner wrote:
> On 5/22/2011 6:19 PM, Brad Campbell wrote:
>
>> They're not variable. Or to put it another way, if they _can_ vary the
>> spindle speed none of mine ever do.
>
> There's too little official info from WD on what exactly the variable
> speed IntelliPower actually means.
>

I can actually answer that one with certainty.

Intellipower is a combination of a fixed (but mostly non-standard) spin 
speed, clever cache usage and a variable speed seek.

It's the variable speed seek that trips people up. The drive knows where 
it is in its rotational cycle, and it knows how far it has to move to 
read the next block. If its rotational latency (and remember it's 
_slow_) is going to be greater than its seek time, it slows the seek 
down to save power. No point snapping the head to the next block if it 
is just going to have to wait for the data to arrive.

Unfortunately early on a couple of "benchmark" sites got it horribly 
wrong, it then got picked up by sites that are normally pretty reliable 
(Anandtech for example) and it just propagated from there.

If anyone would like concrete proof, I'm willing to sacrifice a 1TB 
drive I have here by popping the top and putting an optical tacho on it. 
Just give me a couple of weeks to get it out of service and get an 
optical tacho approved by the war office ;)

> And btw, HDDs pull the bulk of their power from the 5 volt rail, not the
> 12 volt rail.  This is the main differentiating factor between a server
> PSU and a PC PSU--much more current available on the 5v rail.  Hop on
> NewEgg and compare the 12v and 5v rail current of an PC SLI PSU and a
> server PSU.

Have another look at the drive data sheets. The bulk of the load on the 
+12V rail is the drive motor while spinning up. Even my Cheetah's detail 
this accurately in the data sheet. The logic is +5V but the magnetics 
tend to lean on the +12v rail pretty heavily.

> I think a lot of people fell into this 'trap' due the super low price/GB
> of the Green drives, and simply not realizing we now have boutique hard
> drives and a variety of application tailored drives, just as we have 31
> flavors of ice cream.

I kinda knew what I was getting myself into. Here's my reasoning.

The bulk of my storage is what you would call nearline. Write once, read 
lots but not very often. Media, movies, source trees, backups.

My storage used to be spread across 2 servers (30 drives in total) and 
one of those was comprised of 15 250G Maxtors. I did the power 
calculations and figured I could justify replacing 10 1TB drives in 
Server A with 10 WD GP 2T drives and decommission server B.

This will pay for itself in 14 Months.

I did a lot of research on the GP drives and figured for my use pattern 
they'd be ok. Remember, I keep the server up 24/7. It's on an APC Smart 
UPS (boost/buck + UPS) and it gets rebooted for kernel updates every 200 
days or so, but never powered down.

My experience has been that even with the cheapest consumer drives, if 
you keep them spinning and keep them warm they'll go the distance after 
weeding out the early life failures. Now, I might have a time bomb 
sitting there and suffer massive drive failure next week totalling my 
array, but then I knew what I was getting into before I started.

Realizing that for an extra $150 overall I could have had Hitachi 7200 
RPM drives was a bit of a DOH! moment, but then the power savings did 
not stack up as well.

You pays your money, you takes your chances.
