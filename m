From: frank@behner.org
Subject: HA with qlogic FC and linux raid
Date: Sun, 19 Jan 2003 13:45:05 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1042980305.3e2a9dd18c42a@secure.private.behner.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

We try to build a HA environment for a Document Management System. Before I come
to the problem I will briefly describe our setup. We have two buildings and a
fibrechannel switch in each building and attached to it a disk arrays, a DB
server for the metadata (Linux with Oracle) and a fileserver under W2K for the
bulk data. The fileserver runs under W2K, because the application server runs
under W2K. The servers are also connected to the switch in the other building.
The idea is to mirror the data over the buildings. All machines are connected
with two fibres (using QLA2202F cards) to each switch. Also the arrays are using
two connections to the switch. is true for. So we have a multiple pathes from
the machines to the arrays.

The Linux machines are using md-raidtools to mirror over the buildings. To see
the correct number of devices we have used first the failover qlogic driver 6.01
and afterwards the standard version upto 6.04beta4 with the multipath
personality of the mdtools.

The system runs till we need the failover. But if pathes are not available we
get a kernel Oops in the RAID1 personality of the md and any IO to the disk
arrays hangs forever, the machine does also not shutdown correctly. Because we
see this behaviour also if a windows machine boots and sends a LIP reset over
the fibre channel, this is even for normal operations not acceptable. Needless
to say that the W2K do not have this problem. Therefore we concluded that the
setup of the hardware is ok,(BIOS settings are the same for Linux and W2K). Of
course we are unsure whether the problem is in the mdtools or in the qlogic
driver (who should handle the LIP reset). We try to get help from Linux
companies, but we where not very successful.I could send the list Oops and more
information if it would help. Maybe it is well known problem having a raid1
personality over two multipath personalities. (The Oops says something from a
NULL pointer which he can't follow and if I understood it correctly, it happens
after all pathes are gone, due to LIP reset). The LIP reset problem was first
seen while the mirror was resyncing and a windows machine got rebooted.

Thank you for some feedback
     Frank Behner


