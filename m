From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Software RAID 6 initial sync very slow
Date: Tue, 03 Jun 2008 13:08:00 +1200
Message-ID: <48449970.6020704@sauce.co.nz>
References: <8CA91F18992AC9E-1724-EAF@webmail-ne13.sysops.aol.com> <4843E8FD.8000601@tmr.com> <8CA92FCA38FE330-1A8-162F@webmail-nb02.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CA92FCA38FE330-1A8-162F@webmail-nb02.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: davidsen@tmr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thomas62186218@aol.com wrote:
> Thank you Bill and Richard for your responses.
> 
> In sync_speed_max, I had already set it to 250000 (250MB/sec). For 
> sync_speed_min, I have 249900 set. My rational behind doing this was to 
> "force" it to go as fast as it can. Any problem with this?

You cannot force it to go faster, as for a RAID6 resync, the limiting 
speed is going to be the maximum write speed of one drive and in 
practice, I found that it self limited to around 60MB/s.

Regards,

Richard
