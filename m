From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID1 performance and "task X blocked for more than 120 seconds"
Date: Sun, 18 Nov 2012 15:05:35 -0600
Message-ID: <50A94D9F.3060601@hardwarefreak.com>
References: <50A92B52.7030905@mindconnect.nl>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A92B52.7030905@mindconnect.nl>
Sender: linux-raid-owner@vger.kernel.org
To: mailinglist@mindconnect.nl
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/18/2012 12:39 PM, Martijn wrote:

> - Disks are all Seagate Barracuda 7200.12 ST31000528AS, 1TB.
> - NCQ is disabled by setting queue_depth to 1.

WRT write throughput, you have effectively a single 7.2k spindle.  The
only way to get lower performance is a 5xxx RPM 'green' or laptop drive.
 This is a low performance machine.

> The problem:
> I was copying 3 GB of data using rsync, from another server to this
> machine over a 100 mbit connection. After some time it appeared to me as
> if one of the two systems was having trouble keeping up. Copying speed
> was a few MB/s and the transfer sometimes stopped for a longer period of
> time, then to continue again.
> 
> Looking at the receiving system, I noticed this in syslog:
> task kjournald blocked for more than 120 seconds
> task dkpg-preconfigure blocked for more than 120 seconds
> [...]
> 
> dpkg-preconfigure being a process running at that time.

Multiple disk intensive processes running concurrently.

> Eventually, the copy completed. But some time after the copy was
> completed, I still noticed a high (50-80%) %iowait and 2000 to 4000
> blocks being written to sda and sdb. I monitored this using iostat.

This is the buffer cache flushing.

> I waited for the system to return to 0 writes and a load of near 0 when
> I attempted to copy the data on disk from directory A to B, and the same
> problem occured.

Your previously mentioned symptoms were leading me to this, but this one
kinda seals the deal.  This sounds like classic filesystem free space
fragmentation.  What filesystem is this?  The 3GB of files--are they
large or small files?

-- 
Stan


