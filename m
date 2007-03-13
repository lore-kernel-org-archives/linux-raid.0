From: Laurent CARON <lcaron@unix-scripts.info>
Subject: Issue with Adaptec AIC-7899P using MD on Dell PE 2650
Date: Tue, 13 Mar 2007 12:20:01 +0100
Message-ID: <45F688E1.5040303@unix-scripts.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-poweredge@dell.com
List-Id: linux-raid.ids

Hi,

I'm happily using MD on one of our fileservers.

This fileserver is basically a Dell PowerEdge 2650 loaded with 5x300GB HDDs.

A 1TB Raid5 partition is defined over the 5 disks

md1 : active raid5 sdb3[5] sde3[4] sdd3[3] sdc3[2] sda3[0]
      1170238464 blocks level 5, 64k chunk, algorithm 2 [5/4] [U_UUU]

Today, one of the HDDs failed:
I got a lot of errors like this one in the logs
raid5:md1: read error not correctable (sector 153334912 on sdb3).

I failed/removed the disk from the array

mdadm /dev/mdX -f /dev/sdbX
mdadm /dev/mdX -r /dev/sdbX

I then removed it from the scsi bus "echo .... > /proc/scsi/scsi"

Removed the disk from the server (phisically)

Inserted a new one

Did rescan the SCSI bus to detect the new HDD, and the server froze.

This is the second time it happens while changing a hard disk on that
particular brand/model.

Is this a known issue with the SCSI HBA?

Did i do something wrong ?

Thanks

Laurent
