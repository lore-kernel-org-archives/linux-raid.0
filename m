From: Arka Sharma <arka.sw1988@gmail.com>
Subject: mdadm I/O error with Ddf RAID
Date: Fri, 11 Nov 2016 09:15:11 +0530
Message-ID: <CAPO=kN2QDLEMgo9p9pU3=MeLQ=J6R8eeDL1Pw9m2pHjbVsuFGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

We have developed a RAID creation application which create RAID with
Ddf RAID metadata. We are using PCIe ssd as physical disks. We are
writing the anchor, primary, secondary headers, virtual and physical
records, configuration record and physical disk data. The offsets of
the headers are updated in the primary, secondary and anchor headers
correctly. The problem is when we try to boot to Ubuntu server and we
observe that mdadm is throwing a disk failure error message and from
block layer we are getting rw=0, want=7, limit=1000215216. We also
confirmed using there is no I/O error is coming from the PCIe ssd,
using a logic analyzer. Also the limit value 1000215216 is the
capacity of the ssd in 512 byte blocks. Any insight will be highly
appreciated.

Regards,
Arka
