From: Brad Campbell <brad@wasp.net.au>
Subject: Raid-0 speed
Date: Wed, 25 Aug 2004 09:05:39 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <412C1E23.1070104@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,


As you would see I have a problem with libata drivers and raid-0.
In the process of debugging this I have been doing some speed/throughput tests.

On my machine, running 2 instances of dd in 2 terminals
dd if=/dev/sdk of=/dev/null &
dd if=/dev/sdl of=/dev/null

I see over 100MB/s read from VMSTAT.
If I pass the dd via pipebench to /dev/null I see between 50-60MB/s read speed from each drive 
simultaneously.

With the raid-0 running, doing a dd if=/dev/md1 of=/dev/null I get about 55MB/s read speed.

I can't quite figure out why the md is so slow. Given its using streaming reads with no seeking it 
should be over 100MB/s.

Raid-0 created with
mdadm --create --chunk=128 --level=0 --raid-devices=2 /dev/md1 
/dev/scsi/host12/bus0/target0/lun0/disc /dev/scsi/host13/bus0/target0/lun0/disc

Am I doing something obviously silly?

Also, doing a dd from 4 drives maxes out my read speed as per mdstat at 160MB/s (How? PCI is 133MB/s 
and according to lspci all my controllers are on the same bus). Does vmstat lie?

Regards,
Brad
