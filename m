From: Phil Turmel <philip@turmel.org>
Subject: Re: Offline array, events count mismatch
Date: Tue, 10 Nov 2015 10:50:27 -0500
Message-ID: <56421243.9030000@turmel.org>
References: <1903758.3ih4aa4jR2@carbon.lepommierdujardin.fr>
 <56401471.2040605@turmel.org>
 <1970874.nKIz6W3yCk@carbon.lepommierdujardin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1970874.nKIz6W3yCk@carbon.lepommierdujardin.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Paumier <guillaume.paumier@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/09/2015 10:05 PM, Guillaume Paumier wrote:
> Hello Phil and the list,

> Thank you for confirming, Phil, and for the additional pointer.
> 
> I've re-assembled the array with --force, which cleaned sdj, and then I was 
> able to re-add the two other disks. The array started rebuilding and recovery 
> was past 10% when the array failed again.
> 
> It seems there was an "unrecoverable read error" on sdj, and now I'm back with 
> an array where 2 of the disks are marked as spare (sde and sdf, because their 
> rebuild didn't complete), and sdj is faulty with an event count mismatch of 4, 
> like before:

Yes, you're going to lose some data.

Your only path forward at this point is to --assemble --force without
the spares, and leave them out.  The array will be running degraded.

Apply the timeout mismatch work-arounds suited to your drives.

Start copying out your files to a new backup destination.  Keep track
which ones succeed.

/dev/sdj has 48 pending bad sectors.  You are likely to have files that
cannot be read thanks to those sectors.  Just skip them and keep going
(for now).  Note the sector addresses that fail.

You may have to do forced assembly multiple times to get through the
entire backup.

Write zeroes over the bad sectors to clear the UREs.  If the files are
worthless with those zeroes in them, just delete them.  Do this for all
drives that have UREs.  Then you can add the spares back in to rebuild.

Going forward, you need to apply work-arounds for non-raid drives at
every power cycle, buy raid-rated drives for future replacements, and
use cron to run regular scrubs to keep the UREs under control.

Show the smartctl reports for all of your drives if you'd like more
specfic advice.  And turn off word wrapping when you paste, please.

Phil

