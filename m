From: Hannes Dorbath <light@theendofthetunnel.de>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
Date: Wed, 18 Jul 2007 13:26:11 +0200
Message-ID: <469DF8D3.8020908@theendofthetunnel.de>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan> <20070718110525.GF13772@boogie.lpds.sztaki.hu> <Pine.LNX.4.64.0707180718000.7659@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707180718000.7659@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org
List-Id: linux-raid.ids

On 18.07.2007 13:19, Justin Piszcz wrote:
> For the HW RAID tests (2) at the bottom of the e-mail, no, I did not set 
> nr_requests or use the deadline scheduler.
> 
> For the SW RAID tests, I applied similar optimizations, I am probably 
> not at the latest firmware.  The main thing I wanted to use though was 
> SW RAID because the card itself offers so many ports, however, with 
> write speed being that slow I am not sure its a good idea.

I think what you might be experiencing is that XFS can read su,sw values 
from the MD device and will automatically optimize itself, while it 
can't do that for the HW RAID device. It is absolutely essential to 
align your file system, to prevent implicit reads, needed for parity 
calculations.

Set su to the stripe size you have configured in your controller (like 
128K) and sw to 9 (for a 10 disk RAID 5 array).


-- 
Regards,
Hannes Dorbath
