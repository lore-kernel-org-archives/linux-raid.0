From: Steve Witt <sawitt@electra.rsc.raytheon.com>
Subject: RAID/Backup Strategies
Date: Wed, 3 Mar 2004 09:35:41 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0403030912270.10347@zeus.rsc.raytheon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a bit of a newbie question and hope this is appropriate for this
list, so apologies in advance.

We are hoping (if funding is approved) to get a new server to replace an
old server currently in use. The server is primarily an NIS/NFS server
supporting a software development computing center. The current server has
kind of a hodge-podge of IDE and SCSI disks (no RAID) and a SCSI
multi-tape backup device, using amanda as the backup application. A
previous sys admin set up the user disk partitions on this server to be
around 20 GB to match a 20 GB holding partition for amanda.

The new server is planned to have a RAID 5 array with 4 disks plus 1
spare. The software base for this would be Linux (Debian woody) using a
recent 2.4.x kernel.  We plan to use the software RAID facilities in
Linux, not a hardware RAID controller. My understanding of RAID is that
this would result in a single, large device -- /dev/md0. This is great and
I plan put all the user accounts on a filesystem on /dev/md0 and NFS serve
those to all the client machines (mostly Linux, some Sun) we have.

The thing I am confused about is how this will affect our amanda backup
strategy. The array size will be a little over 700 GB. To follow our
current amanda setup it seems that the RAID device should be split into
multiple partitions with one dedicated as a holding partition for amanda.
But I'm not sure this is possible or desireable with a RAID array.

Any ideas, comments?

Thanks...


