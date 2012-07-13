From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: Assembly failure
Date: Sat, 14 Jul 2012 08:34:40 +1200
Message-ID: <50008660.7020905@clear.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brian Candler wrote:

------------------------------------

One final point. I would like to be able to monitor for suspect or failed
drives.  Is my best bet to look at /proc/mdstat output and identify drives
which have been kicked out of the array?  Or to monitor SMART variables (in
that case though I need to decide which ones are the most important to
monitor, and what thresholds to set)?

-------------------------------------------

For years I have used smartd without issues and it will log and email 
anomalies as they occur.

It is also advisable to regularly "scrub" all md devices, to flush out 
faulty sectors:

echo check > /sys/block/mdX/md/sync_action

See Documentation/md.txt for details.

Regards,

Richard
