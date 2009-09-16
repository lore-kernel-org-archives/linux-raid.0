From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Port Multipliers
Date: Wed, 16 Sep 2009 16:34:50 +0100
Message-ID: <4AB1059A.4010705@anonymous.org.uk>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>  <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>  <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com> <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com> <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/09/2009 18:56, Doug Ledford wrote:
> On Sep 10, 2009, at 2:44 PM, Majed B. wrote:
>> The maximum throughput you'll get is the PCI bus's speed. Make sure to
>> note which version your server has.
>>
>> The silicon image controller will be your bottleneck here, but I don't
>> have any numbers to say how much of a loss you'll be at. You'd have to
>> search around for those who already benchmarked their systems, or
>> buy/request a card to test it out.
> 
> I've actually been doing some of those benchmarks here.  Given a Silicon 
> Image 3124 card in a x1 PCI-e slot, my maximum throughput should be 
> about 250MB/s (PCI-e limitation).  My drives behind the pm are all 
> capable of about 80MB/s, and I have 4 drives.  What I've found is that 
> when accessing one drive by itself, I get 80MB/s.  When accessing more 
> than one drive, I get a total of about 120MB/s, but it's divided by 
> however many drives I'm accessing.  So, two drives is roughly 60MB/s 
> each, 3 drives about 40MB/s each, and 4 drives about 30MB/s each.

Were you using a SiI3124-1 (1.5Gbps, they claim 150MB/s) or SiI3124-2 
(3Gbps/300MB/s)? What throughput can you get using all 4 channels of the 
SiI3124 simultaneously, not using the port multiplier - does that top 
out at 120MB/s too?

And have you done similar testing of your port multiplier hanging off a 
motherboard SATA port? Do you get anywhere nearer the 3Gbps?

Just interested...

Cheers,

John.

