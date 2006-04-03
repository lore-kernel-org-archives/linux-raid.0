From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Softraid controllers and Linux
Date: Mon, 3 Apr 2006 09:36:52 +0400
Message-ID: <541048249.20060403093652@2ka.mipt.ru>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello linux-raid,

  I have tried several cheap RAID controllers recently (namely,
  VIA VT6421, Intel 6300ESB and Adaptec/Marvell 885X6081).
  
  VIA one is a PCI card, the second two are built in a Supermicro
  motherboard (E7520/X6DHT-G).

  The intent was to let the BIOS of the controllers make a RAID1
  mirror of two disks independently of an OS to make redundant
  multi-OS booting transparent. While DOS and Windows saw their
  mirrors as a singular block device, Linux (FC5) accessed the
  two drives separately on all adapters.

  Is this a bug or a feature of the kernel driver support? (I did
  not try vendors' binary drivers, if there are any).

-- 
Best regards,
 Jim Klimov                          mailto:klimov@2ka.mipt.ru

