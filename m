From: "Dr. Uwe Meyer-Gruhl" <f+gmane@congenio.de>
Subject: Problems with device-mapper on top of RAID-5 and RAID-6
Date: Fri, 02 Jun 2006 17:10:19 +0200
Message-ID: <448054DB.1020004@congenio.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List,


just to draw your attention to some discussion starting out here:

http://thread.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/1576/focus=1576

and going on here:

http://thread.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/1617/focus=1617

To recap, what has been found so far is:

1. There are problems with the combination of RAID and device mapper 
(e.g. for encrypted filesystems). The thread started off with this 
observation.
2. There are filesystem corruptions with heavy loads (i.e. copying big 
files or many files to the filesystem). The bug usually takes long to 
reproduce.
3. Problems occur with any filesystem type (ext3, reiser4 et. al.).
4. Problems occur with RAID-5 and RAID-6. Both are O.K. without dm-crypt.
5. Problems are unaffected by different ciphers under dm-crypt (at least 
AES, Serpent and Twofish expose the bug). dm-linear is reported to have 
failed, too. So, we suspect that neither dm-crypt nor ciphers are the 
culprit here, but rather the device mapper core functionality or RAID 
subsystem.
6. Bug seems to exist in at least kernel 2.6.13 to 2.6.16 (2.6.17 not 
yet tested, earlier versions may be affected).

There have been discussions going on about his from earlier kernel 
versions, like here:

http://lwn.net/Articles/150583/

Neil's suggestion indicates that there may be a race condition stacking 
md and dm over each other, but I have not yet tested that patch. I once 
had problems stacking cryptoloop over RAID-6, so it might really be a 
stacking problem. We don't know yet if LVM over RAID is affected as well.

This bug is very critical and should be fixed as soon as possible, IMHO.



Uwe
