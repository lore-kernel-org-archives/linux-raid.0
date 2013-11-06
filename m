From: Hans Kraus <hans@hanswkraus.com>
Subject: Re: Timeout question
Date: Wed, 06 Nov 2013 07:49:03 +0100
Message-ID: <5279E65F.8020209@hanswkraus.com>
References: <5277FE65.8050001@hanswkraus.com> <5278220C.3060607@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5278220C.3060607@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Phil,

thanks. Debian does already a scrub every first Sunday of a month.
Upgrading to a Raid6 is planned when I have the money for the disk(s).

I already encountered a second failure during rebuild of a raid5, (that
was the trigger for the backup solution), so I'm very aware of that
possibility. My main storage is already a raid6, on NAS drives.

Kind regards, Hans

Am 04.11.2013 23:39, schrieb Phil Turmel:
 > [...]
 >> Afterwards, these four raid0 are the members of a raid5. The idea
 >> behind this is to be able to replace the raid0 with single 4 TB drives.
 >> Now comes my question: Do I need to care for timeouts of the raid0, and
 >> if so, how do I do that? The following doesn't work:
 >> for x in md??; do
 >>      /bin/echo $x
 >> 
"--------------------------------------------------------------------------"
 >>
 >>      echo 180 >/sys/block/$x/device/timeout || echo
 >> "/sys/block/$x/device/timeout not available"
 >>      /bin/echo
 >> 
"-------------------------------------------------------------------------------"
 >>
 >>   done
 >
 > No.  The timeouts only matter on the physical devices.  MD doesn't have
 > a timeout as it isn't a physical driver.  What you have appears to be
 > correct.
 >
 > Make sure you also have a "check" scrub in a cron job for everything
 > greater than raid0.  (Interval can vary--I use weekly.)  And follow up
 > on the cron job with a report of all mismatch-cnt values.
 >
 > For large capacities with consumer drives (~8TB or more, IMHO), you
 > should seriously consider raid6.  The probability of an unrecoverable
 > read error interrupting a raid5 rebuild after a drive failure is
 > shockingly high.
 >
 > HTH,
 >
 > Phil


