From: Peter Hoeg <peter@hoeg.com>
Subject: Add BBL to existing array
Date: Wed, 27 Aug 2014 18:32:13 +0800
Message-ID: <20140827103213.GE15857@dolores.internal.speartail.com>
References: <20140827090707.GA15857@dolores.internal.speartail.com>
 <20140827192721.57c57c3b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140827192721.57c57c3b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

this isn't so much a question as it trying to document the situation
with BBL's on Debian jessie, although if I've overlooked something,
please let me know.

Purpose: Add BBL to a RAID created by an earlier version of mdadm
without BBL support.

# mdadm --version

mdadm - v3.3 - 3rd September 2013


# uname -a

Linux edith 3.14-2-amd64 #1 SMP Debian 3.14.15-2 (2014-08-09) x86_64 GNU/Linux


# cat /proc/mdstat

Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sda2[0] sdd2[4] sdc2[3] sdb2[1]
      5859439616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
      bitmap: 1/2 pages [4KB], 1048576KB chunk

unused devices: <none>


As the system boots from the RAID, I thought I could be clever and
simply edit /usr/share/initramfs-tools/scripts/local-top/mdadm and
change the "--assemble" statements to add "--update=bbl" which should
take care of things after a reboot.

It basically runs:
# mdadm --assemble --scan --run --auto=yes

so it would become:
# mdadm --assemble --update=bbl --scan --run --auto=yes


That didn't work. I ended up in the initramfs and had to manually bring
up the RAID as well as LVM to get the machine booted.

Now, according to the manual with the version of mdadm on the machine,
'--update=bbl' is supported, however when asking mdadm directly, it
doesn't seem to be the case:

# mdadm --assemble --update=?

mdadm: Valid --update options are:
     'sparc2.2', 'super-minor', 'uuid', 'name', 'resync',
     'summaries', 'homehost', 'byteorder', 'devicesize',
     'no-bitmap', 'metadata', 'revert-reshape'

So in all likelyhood, this is a Debian packaging issue.

If anyone answers, please CC me as I am not subscribed to the list, thanks.

--
Regards,
Peter
