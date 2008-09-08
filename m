From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Slow RAID5 build on ata_piix vs. fast on sata_mv
Date: Mon, 8 Sep 2008 13:50:21 -0400
Message-ID: <20080908175021.GA7730@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On kernel 2.6.26.3 with mdadm 2.6.7, I'm building two RAID5 arrays of
three drives each from six Seagate 1TB drives (ST31000340NS) on two
different controllers.

Initial creation is rather slow for the array of disks on onboard
controller, about ~17MB/sec.  The creation of the array on the PCI-X
controller was much faster, about ~90MB/sec.  (Note: the creation is
sequential, I'm not creating these two arrays simultaneously.)

Three drives on one array are connected to the onboard SATA controller of
an Asus P5EWS Pro motherboard.  lspci shows me two IDE interfaces, one
four port and the other two port which I suppose correspond, in total,
to the six onboard ports:

Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH)
  4 port SATA IDE Controller (rev 02)
Intel Corporation 82801I (ICH9 Family)
  2 port SATA IDE Controller (rev 02)

They both use the ata_piix kernel module.


The other controller is an eight port SuperMicro PCI-X controller,
AOC-SAT2-MV8, which has been mentioned on the list in the past:

Marvell Technology Group Ltd. 88SE6145 SATA II PCI-E controller (rev a1)

It uses the sata_mv kernel module.


I've created both RAID5 arrays with default parameters, using simply:
  mdadm --create /dev/md2 --raid-devices=3 --level=raid5
    /dev/sdd2 /dev/sde2 /dev/sdf2


hdparm shows me all drives are using udma6 (e.g. "hdparm -i /dev/sda"),
so I don't think it's a DMA issue (anyway, I've read all SATA drives use
DMA.. ?).

It seems like a controller issue.  Perhaps a different driver is
available for the onboard Intel controller; or some tunables in libata?

Any suggestions?

Thanks,
Richard
