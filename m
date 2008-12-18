From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: upgrade advice
Date: Thu, 18 Dec 2008 17:18:11 +0000
Message-ID: <494A85D3.7020805@anonymous.org.uk>
References: <d5fe39840812160310t45e822c1geb633f805cf5388e@mail.gmail.com> <1229428184.22331.43.camel@localhost> <alpine.DEB.1.10.0812160807200.725@p34.internal.lan> <1229436950.22331.45.camel@localhost> <cccedfc60812160757x2af73afbv4a69eac31d212062@mail.gmail.com> <alpine.DEB.1.10.0812161829490.31132@p34.internal.lan> <cccedfc60812161608y29e6c645n6ff7df5c87292374@mail.gmail.com> <1229497160.22331.73.camel@localhost> <cccedfc60812170526l43c661ddgff95c99ea883f362@mail.gmail.com> <A20315AE59B5C34585629E258D76A97C030D4837@34093-C3-EVS3.exchange.rackspace.com> <cccedfc60812170637j7eab2c4cyac88fc110b51755f@mail.gmail.com> <A20315AE59B5C34585629E258D76A97C030D48CC@34093-C3-EVS3.exchange.rackspace.com> <494A7C61.6080805@anonymous.org.uk> <alpine.DEB.1.10.0812181140260.28725@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812181140260.28725@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18/12/2008 16:43, Justin Piszcz wrote:
> On Thu, 18 Dec 2008, John Robinson wrote:
>> On 17/12/2008 15:30, David Lethe wrote:
>>> The duty cycle makes a difference now, but wasn't a design point until
>> [...]
>>> OK, off my soapbox ... back to work writing disk diagnostic software for
>>> my OEM customers 
>>
>> I am going to print that message, frame it and hang it on the wall. 
>> (Including the bit I elided with ...)
>>
>> I'll probably keep using desktop drives for domestic NAS, though.
> I think it also depends on how often drives are used and what type of 
> workloads they are exposed to, for a domestic NAS for mainly sequential 
> file writes/reads, they will probably be OK-- I have a few SW RAID5's on 
> desktop drives but I use them primarily as storage via rsync, once a 
> week or month I am not constantly read/writing on them-- on a daily 
> basis.  Is that how you use your NAS as well?  Or?

I have 2 scenarios. For myself, I've a big box I put together myself, 
with a P45-chipset mobo, a Core 2 Quad, 4GB RAM (so far), a Supermicro 
hot-swap SATA enclosure and 3 1TB Samsungs in Linux RAID-5, which serves 
both my IT support work where I work from home (storing ISO images, 
running various Windows and Linux VMs mostly for testing/development) 
and my domestic NAS demands (MythTV server, SqueezeCenter, and backups 
of other PCs). It's on 24/7 but there's only me to make demands of it so 
it doesn't get very heavily exercised. I'll probably replace the current 
Samsungs (which have consecutive serial numbers) over time, even if they 
aren't failing, with others from other batches and other makes. I always 
recommend my business clients use enterprise drives in any central 
storage application (but it seems I don't take my own advice when it 
comes to myself).

I am also involved in an assisting capacity with a group of home and 
multiroom hifi folks, who need NASes for storing the music to stream to 
TwonkyMedia, SqueezeCenter etc. We like the ReadyNAS range (Linux RAID 
based), and have tried Seagate desktop and enterprise drives as well as 
the Samsung desktop drives. So far so good, no problems, and we like the 
Samsungs best so far, because they're quieter and have been cheaper. The 
ReadyNAS knows how to sleep, so desktop drives should be fine here as 
they'll be shut down when people aren't playing their hifi (though 
there's a bug in current versions of SqueezeCenter that stops the drives 
sleeping if your Duet remote's turned on) and they're rarely doing 
anything strenuous.

As always, I'd appreciate comments from people better informed than me!

Cheers,

John.

PS. Who mentioned big autochangers? Somebody did. Anyway, I just bought 
a Dell PowerVault 132T off eBay with an LTO-2 drive for next to nothing 
:-) so I shall have many happy hours backing up my 2TB array onto lots 
of tapes.
