From: David Greaves <david@dgreaves.com>
Subject: Re: [PERFORM] Postgres on RAID5 (possible sync blocking read type
 issue on 2.6.11)
Date: Mon, 14 Mar 2005 07:44:53 +0000
Message-ID: <423540F5.8090609@dgreaves.com>
References: <4231F5F2.6000509@m-cam.com> <87hdje7sjm.fsf@stark.xeocode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <87hdje7sjm.fsf@stark.xeocode.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Stark <gsstark@mit.edu>
Cc: Arshavir Grigorian <ag@m-cam.com>, linux-raid@vger.kernel.org, pgsql-performance@postgresql.org
List-Id: linux-raid.ids

Greg Stark wrote:

>Arshavir Grigorian <ag@m-cam.com> writes:
>
>  
>
>>Hi,
>>
>>I have a RAID5 array (mdadm) with 14 disks + 1 spare. This partition has an
>>Ext3 filesystem which is used by Postgres. 
>>    
>>
>
>People are going to suggest moving to RAID1+0. I'm unconvinced that RAID5
>across 14 drivers shouldn't be able to keep up with RAID1 across 7 drives
>though. It would be interesting to see empirical data.
>
>One thing that does scare me is the Postgres transaction log and the ext3
>journal both sharing these disks with the data. Ideally both of these things
>should get (mirrored) disks of their own separate from the data files.
>
>But 2-3s pauses seem disturbing. I wonder whether ext3 is issuing a cache
>flush on every fsync to get the journal pushed out. This is a new linux
>feature that's necessary with ide but shouldn't be necessary with scsi.
>
>It would be interesting to know whether postgres performs differently with
>fsync=off. This would even be a reasonable mode to run under for initial
>database loads. It shouldn't make much of a difference with hardware like this
>though. And you should be aware that running under this mode in production
>would put your data at risk.
>
Hi
I'm coming in from the raid list so I didn't get the full story.

May I ask what kernel?

I only ask because I upgraded to 2.6.11.2 and happened to be watching 
xosview on my (probably) completely different setup (1Tb xfs/lvm2/raid5 
served by nfs to a remote sustained read/write app), when I saw all read 
activity cease for 2/3 seconds whilst the disk wrote, then disk read 
resumed. This occured repeatedly during a read/edit/write of a 3Gb file.

Performance not critical here so on the "hmm, that's odd" todo list :)

David

