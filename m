From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Mon, 19 Jun 2006 17:05:56 +0200
Message-ID: <20060619150556.GQ11429@boogie.lpds.sztaki.hu>
References: <20060614085354.GA18106@rigacci.org> <44902F41.8030300@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44902F41.8030300@rcn.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Cizek <cizek@rcn.com>
Cc: Niccolo Rigacci <niccolo@rigacci.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 14, 2006 at 10:46:09AM -0500, Bill Cizek wrote:

> I was able to work around this by lowering 
> /proc/sys/dev/raid/speed_limit_max to a value
> below my disk thruput value (~ 50 MB/s) as follows:

IMHO a much better fix is to use the cfq I/O scheduler during the
rebuild. The default anticipatory scheduler gives horrible latencies
and can cause the machine to appear as 'locked up' if there is heavy
I/O load like a RAID reconstruct or heavy database usage.

The price of cfq is lower throughput (higher RAID rebuild time) than
with the anticipatory I/O scheduler.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
