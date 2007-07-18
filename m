From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
Date: Wed, 18 Jul 2007 13:05:26 +0200
Message-ID: <20070718110525.GF13772@boogie.lpds.sztaki.hu>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 18, 2007 at 06:23:25AM -0400, Justin Piszcz wrote:

> I recently got a chance to test SW RAID5 using 750GB disks (10) in a RAID5 
> on a 3ware card, model no: 9550SXU-12
>
> The bottom line is the controller is doing some weird caching with writes 
> on SW RAID5 which makes it not worth using.

Did you use the settings documented in
http://www.3ware.com/KB/article.aspx?id=11050 ? Setting nr_requests and
the deadline scheduler doubled the seq write performance for me. Do you
have the latest firmware? Firmware updates can improve performance - at
least for RAID5/6; I somewhat doubt that they care about JBOD
performance that much...

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
