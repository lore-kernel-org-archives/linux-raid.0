From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 17:01:07 -0400
Message-ID: <00ab01c5ae6f$1bb27410$c100a8c0@NCNF5131FTH>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH> <43160DF2.6000504@tls.msk.ru>  <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH> <1125520778.3194.18.camel@x1-6-00-0d-60-fd-e8-4c> <008b01c5ae6c$e4db5e90$c100a8c0@NCNF5131FTH> <1125521616.3194.22.camel@x1-6-00-0d-60-fd-e8-4c>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Forrest Taylor <ftaylor@redhat.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2005-08-31 at 14:55, Forrest Taylor wrote:
>On Wed, 2005-08-31 at 14:45, David M. Strang wrote:
>> > On Wed, 2005-08-31 at 14:39, Forrest Taylor wrote:
>> > If you are running 2.4 kernel, did you try running rescan-scsi-bus.sh
>> > (http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh)?
>>
>> uname -ar
>> Linux abyss 2.6.11.12 #2 SMP Thu Jul 21 07:49:40 UTC 2005 i686 unknown
>> unknown GNU/Linux
>>
>> Will it work on 2.6?
>
> I thought that it was integrated into 2.6 kernels (I guess that I was
> wrong).  In the header of the file, Kurt says that he tested in on a
> 2.6.11 kernel, so I assume that it would work on a 2.6 kernel ;o)

OK, well - ignore my moron attack on the previous reply; I adjusted it to 
scan for 30 ids, instead of just 7.

Host adapter 0 (aic7xxx) found.
Host adapter 1 (aic7xxx) found.
Host adapter 2 (qla2xxx) found.
Scanning hosts  0 1 2 channels 0 for
 SCSI target IDs  0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 
23 24 25 26 27 28 29 30 , LUNs  0
Scanning for device 1 0 6 0 ....
OLD: Host: scsi1 Channel: 00 Id: 06 Lun: 00
      Vendor: HP       Model: Ultrium 1-SCSI   Rev: E34A
      Type:   Sequential-Access                ANSI SCSI revision: 03
Scanning for device 2 0 0 0 ....
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
Scanning for device 2 0 8 0 ...
OLD: Host: scsi2 Channel: 00 Id: 08 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 9 0 ...
OLD: Host: scsi2 Channel: 00 Id: 09 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 10 0 ...
OLD: Host: scsi2 Channel: 00 Id: 10 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 11 0 ...
OLD: Host: scsi2 Channel: 00 Id: 11 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 12 0 ...
OLD: Host: scsi2 Channel: 00 Id: 12 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 13 0 ...
OLD: Host: scsi2 Channel: 00 Id: 13 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 14 0 ...
OLD: Host: scsi2 Channel: 00 Id: 14 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 15 0 ...
OLD: Host: scsi2 Channel: 00 Id: 15 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 16 0 ...
OLD: Host: scsi2 Channel: 00 Id: 16 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 17 0 ...
OLD: Host: scsi2 Channel: 00 Id: 17 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 18 0 ...
OLD: Host: scsi2 Channel: 00 Id: 18 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 19 0 ...
OLD: Host: scsi2 Channel: 00 Id: 19 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 20 0 ...
OLD: Host: scsi2 Channel: 00 Id: 20 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 21 0 ...
OLD: Host: scsi2 Channel: 00 Id: 21 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 22 0 ...
OLD: Host: scsi2 Channel: 00 Id: 22 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 23 0 ...
OLD: Host: scsi2 Channel: 00 Id: 23 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 24 0 ...
OLD: Host: scsi2 Channel: 00 Id: 24 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 25 0 ...
OLD: Host: scsi2 Channel: 00 Id: 25 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 26 0 ...
OLD: Host: scsi2 Channel: 00 Id: 26 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
Scanning for device 2 0 27 0 ...
OLD: Host: scsi2 Channel: 00 Id: 27 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03
0 new device(s) found.
0 device(s) removed.

It sees the device in question:

Scanning for device 2 0 12 0 ...
OLD: Host: scsi2 Channel: 00 Id: 12 Lun: 00
      Vendor: SEAGATE  Model: ST373405FC       Rev: DF00
      Type:   Direct-Access                    ANSI SCSI revision: 03


Is there something a little deeper to this error message?

Aug 31 04:48:15 abyss kernel: scsi2 (12:0): rejecting I/O to offline device
Aug 31 04:48:15 abyss kernel: raid5: Disk failure on sdm, disabling device.

-- David


