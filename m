From: Sean Puttergill <puttergi@yahoo.ca>
Subject: Auto-assembling arrays using mdadm
Date: Thu, 9 Mar 2006 03:54:06 -0500 (EST)
Message-ID: <20060309085406.54370.qmail@web35312.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

I am looking to script auto-assembly of all arrays
detected on an arbitrary set of drives using mdadm.

The way I am thinking of doing this is as follows:

mdadm.conf =

DEVICE /dev/sd*

----

1. Use "mdadm -E" on each drive in turn to get the
UUID for the array to which it belongs and assemble a
list of unique UUIDs.

2. Run "mdadm -A --uuid=<UUID> --auto=md --scan" for
each unique UUID.


My question is, is it currently possible for me to get
mdadm to do this automatically?  Ideally I would
invoke  mdadm once to discover all RAID arrays that
exist on the devices listed in the mdadm.conf file and
assemble them, automatically creating the require md
devices.

I know that I could use kernel RAID autodetect, but I
hear that this is to be deprecated soon.  Also, the
RAID arrays I am using live on bare drives, not
partitions (i.e. no partition to set to type 0xFD).


Thanks,
Sean


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
