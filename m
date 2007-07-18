From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
Date: Wed, 18 Jul 2007 07:19:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707180718000.7659@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
 <20070718110525.GF13772@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070718110525.GF13772@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 18 Jul 2007, Gabor Gombas wrote:

> On Wed, Jul 18, 2007 at 06:23:25AM -0400, Justin Piszcz wrote:
>
>> I recently got a chance to test SW RAID5 using 750GB disks (10) in a RAID5
>> on a 3ware card, model no: 9550SXU-12
>>
>> The bottom line is the controller is doing some weird caching with writes
>> on SW RAID5 which makes it not worth using.
>
> Did you use the settings documented in
> http://www.3ware.com/KB/article.aspx?id=11050 ? Setting nr_requests and
> the deadline scheduler doubled the seq write performance for me. Do you
> have the latest firmware? Firmware updates can improve performance - at
> least for RAID5/6; I somewhat doubt that they care about JBOD
> performance that much...
>
> Gabor
>
> --
>     ---------------------------------------------------------
>     MTA SZTAKI Computer and Automation Research Institute
>                Hungarian Academy of Sciences
>     ---------------------------------------------------------
>

For the HW RAID tests (2) at the bottom of the e-mail, no, I did not set 
nr_requests or use the deadline scheduler.

For the SW RAID tests, I applied similar optimizations, I am probably not 
at the latest firmware.  The main thing I wanted to use though was SW RAID 
because the card itself offers so many ports, however, with write speed 
being that slow I am not sure its a good idea.

Justin.
