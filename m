From: Greg Stark <gsstark@mit.edu>
Subject: Re: [PERFORM] Postgres on RAID5
Date: 13 Mar 2005 23:36:13 -0500
Message-ID: <87hdje7sjm.fsf@stark.xeocode.com>
References: <4231F5F2.6000509@m-cam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4231F5F2.6000509@m-cam.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arshavir Grigorian <ag@m-cam.com>
Cc: linux-raid@vger.kernel.org, pgsql-performance@postgresql.org
List-Id: linux-raid.ids


Arshavir Grigorian <ag@m-cam.com> writes:

> Hi,
> 
> I have a RAID5 array (mdadm) with 14 disks + 1 spare. This partition has an
> Ext3 filesystem which is used by Postgres. 

People are going to suggest moving to RAID1+0. I'm unconvinced that RAID5
across 14 drivers shouldn't be able to keep up with RAID1 across 7 drives
though. It would be interesting to see empirical data.

One thing that does scare me is the Postgres transaction log and the ext3
journal both sharing these disks with the data. Ideally both of these things
should get (mirrored) disks of their own separate from the data files.

But 2-3s pauses seem disturbing. I wonder whether ext3 is issuing a cache
flush on every fsync to get the journal pushed out. This is a new linux
feature that's necessary with ide but shouldn't be necessary with scsi.

It would be interesting to know whether postgres performs differently with
fsync=off. This would even be a reasonable mode to run under for initial
database loads. It shouldn't make much of a difference with hardware like this
though. And you should be aware that running under this mode in production
would put your data at risk.

-- 
greg

