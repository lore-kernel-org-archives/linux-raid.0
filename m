From: Phil Turmel <philip@turmel.org>
Subject: Re: Timeout question
Date: Mon, 04 Nov 2013 17:39:08 -0500
Message-ID: <5278220C.3060607@turmel.org>
References: <5277FE65.8050001@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5277FE65.8050001@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Kraus <hans@hanswkraus.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Hans,

On 11/04/2013 03:07 PM, Hans Kraus wrote:
> Hi,
> 
> I put all my replaced and so on HDs in one machine to serve
> backup duties, with backuppc.
> 
> I assembled four raid0, each consiting of a 3 + 1 TB couple or
> 2 + 2 TB couple. Some of these support scterc, some do not. I've
> put the following in rc.local (by the way, the system is running
> Debian):
> cd /dev
> for x in sd[a-z]; do
>     /bin/echo $x
> "---------------------------------------------------------------------------"
> 
>     /usr/sbin/smartctl -s on -o on -S on /dev/$x || echo
> "/usr/sbin/smartctl -s on -o on -S on /dev/$x failed."
>     /usr/sbin/smartctl -l scterc,70,70 /dev/$x || echo 180
>>/sys/block/$x/device/timeout || echo "/sys/block/$x/device/timeout not
> available"
>     /usr/sbin/smartctl -t offline /dev/$x || echo "/usr/sbin/smartctl -t
> offline /dev/$x failed"
>     /bin/echo
> "-------------------------------------------------------------------------------"

Good.
> 
> done
> 
> Afterwards, these four raid0 are the members of a raid5. The idea
> behind this is to be able to replace the raid0 with single 4 TB drives.
> Now comes my question: Do I need to care for timeouts of the raid0, and
> if so, how do I do that? The following doesn't work:
> for x in md??; do
>     /bin/echo $x
> "--------------------------------------------------------------------------"
> 
>     echo 180 >/sys/block/$x/device/timeout || echo
> "/sys/block/$x/device/timeout not available"
>     /bin/echo
> "-------------------------------------------------------------------------------"
> 
>  done

No.  The timeouts only matter on the physical devices.  MD doesn't have
a timeout as it isn't a physical driver.  What you have appears to be
correct.

Make sure you also have a "check" scrub in a cron job for everything
greater than raid0.  (Interval can vary--I use weekly.)  And follow up
on the cron job with a report of all mismatch-cnt values.

For large capacities with consumer drives (~8TB or more, IMHO), you
should seriously consider raid6.  The probability of an unrecoverable
read error interrupting a raid5 rebuild after a drive failure is
shockingly high.

HTH,

Phil
