From: "Jim Buttafuoco" <jim@contactbda.com>
Subject: Re: [PERFORM] Postgres on RAID5
Date: Mon, 14 Mar 2005 15:35:41 -0500
Message-ID: <20050314202823.M3327@contactbda.com>
References: <4231F5F2.6000509@m-cam.com> <87hdje7sjm.fsf@stark.xeocode.com> <33c6269f050314115339b6861d@mail.gmail.com> <87zmx6rni0.fsf@stark.xeocode.com>
Reply-To: jim@contactbda.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
In-Reply-To: <87zmx6rni0.fsf@stark.xeocode.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Stark <gsstark@mit.edu>, Alex Turner <armtuk@gmail.com>
Cc: Arshavir Grigorian <ag@m-cam.com>, linux-raid@vger.kernel.org, pgsql-performance@postgresql.org
List-Id: linux-raid.ids

All,

I have a 13 disk (250G each) software raid 5 set using 1 16 port adaptec SATA controller.   
I am very happy with the performance. The reason I went with the 13 disk raid 5 set was for the space NOT performance. 
  I have a single postgresql database that is over 2 TB with about 500 GB free on the disk.   This raid set performs
about the same as my ICP SCSI raid controller (also with raid 5).  

That said, now that postgresql 8 has tablespaces, I would NOT create 1 single raid 5 set, but 3 smaller sets.  I also DO
NOT have my wal and log's on this raid set, but on a  smaller 2 disk mirror.

Jim

---------- Original Message -----------
From: Greg Stark <gsstark@mit.edu>
To: Alex Turner <armtuk@gmail.com>
Cc: Greg Stark <gsstark@mit.edu>, Arshavir Grigorian <ag@m-cam.com>, linux-raid@vger.kernel.org,
pgsql-performance@postgresql.org
Sent: 14 Mar 2005 15:17:11 -0500
Subject: Re: [PERFORM] Postgres on RAID5

> Alex Turner <armtuk@gmail.com> writes:
> 
> > a 14 drive stripe will max out the PCI bus long before anything else,
> 
> Hopefully anyone with a 14 drive stripe is using some combination of 64 bit
> PCI-X cards running at 66Mhz...
> 
> > the only reason for a stripe this size is to get a total accessible
> > size up.
> 
> Well, many drives also cuts average latency. So even if you have no need for
> more bandwidth you still benefit from a lower average response time by adding
> more drives.
> 
> -- 
> greg
> 
> ---------------------------(end of broadcast)---------------------------
> TIP 9: the planner will ignore your desire to choose an index scan if your
>       joining column's datatypes do not match
------- End of Original Message -------

