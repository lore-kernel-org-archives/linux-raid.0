From: "Dominik Kubla" <kubla@uni-mainz.de>
Subject: Bug in multipath code (Linux 2.6.x) ?
Date: Wed, 7 Apr 2004 20:33:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <B7A4A15090CB1847A60B569AC92FB9B352D24A@EXSTORE2.zdv.uni-mainz.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org, khoddam@netz.klinik.uni-mainz.de
List-Id: linux-raid.ids

Hi Neil,

It appears to me as if there might be a bug in the multipath code since
it is impossible to activate the multipath device properly. It doesn't
matter if one uses raidtools or mdadm. Every time i try to activate the
mp devices, the system complains about not being able to access the
drive. The result is a mp device with just one path.

Hardware configuration:

Sun Fire v65x with two LSI Logic FC-HBA's connected to two disjunct
switched fabrics.
Fabric switches are four Brocade Silkwork 3600 and storage devices are
two Adv. Unibyte JBODs.

Software configuration:

Debian GNU/Linux (unstable) with kernel 2.6.4.
Two disks are setup up as individual mp devices with a RAID1 on top of
the two mp devices.

I don't have the exact error message at the moment, but can supply it in
case it is needed.

Regards,
  Dominik Kubla
