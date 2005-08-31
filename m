From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 16:53:19 -0400
Message-ID: <009601c5ae6e$04d4d5e0$c100a8c0@NCNF5131FTH>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH> <43160DF2.6000504@tls.msk.ru>  <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH> <1125520778.3194.18.camel@x1-6-00-0d-60-fd-e8-4c> <008b01c5ae6c$e4db5e90$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Forrest Taylor <ftaylor@redhat.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2005-08-31 at 14:45, David M. Strang wrote:
>On Wed, 2005-08-31 at 14:39, Forrest Taylor wrote:
>> If you are running 2.4 kernel, did you try running rescan-scsi-bus.sh
>> (http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh)?

> uname -ar
> Linux abyss 2.6.11.12 #2 SMP Thu Jul 21 07:49:40 UTC 2005 i686 unknown 
> unknown GNU/Linux

> Will it work on 2.6?

http://bash.cyberciti.biz/diskadmin/rescan-scsi-bus.sh.html

Tried the above script...

Host adapter 0 (aic7xxx) found.
Host adapter 1 (aic7xxx) found.
Host adapter 2 (qla2xxx) found.
Scanning hosts  0 1 2 channels 0 for
 SCSI target IDs  0 1 2 3 4 5 6 7 , LUNs  0
Scanning for device 1 0 6 0 ...
OLD: Host: scsi1 Channel: 00 Id: 06 Lun: 00
      Vendor: HP       Model: Ultrium 1-SCSI   Rev: E34A
      Type:   Sequential-Access                ANSI SCSI revision: 03
Scanning for device 2 0 0 0 ...
OLD: Host: scsi2 Channel: 00 Id: 00 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 1 0 ...
OLD: Host: scsi2 Channel: 00 Id: 01 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 2 0 ...
OLD: Host: scsi2 Channel: 00 Id: 02 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 3 0 ...
OLD: Host: scsi2 Channel: 00 Id: 03 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 4 0 ...
OLD: Host: scsi2 Channel: 00 Id: 04 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 5 0 ...
OLD: Host: scsi2 Channel: 00 Id: 05 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 6 0 ...
OLD: Host: scsi2 Channel: 00 Id: 06 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 7 0 ...
OLD: Host: scsi2 Channel: 00 Id: 07 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
0 new device(s) found.
0 device(s) removed.


The output is odd... It only sees 7 of the 28 devices.

-- David
