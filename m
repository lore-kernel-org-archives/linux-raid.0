From: Sushma Gurram <Sushma.Gurram@sandisk.com>
Subject: mdraid with device-mapper multipath devices
Date: Tue, 10 Mar 2015 01:43:46 +0000
Message-ID: <B9FF37F8E2D7894A9493A5314D0816FC242A8196@SACMBXIP01.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Let's say I have a system with two multipath SSDs (dm-0 and dm-1) and a raid0 is created using both.

When the underlying drive for dm-0 is accidentally removed, the multipathd cannot flush the multipath map (because it's being used by mdraid) and hence the dm-0 entry continues to exist and hence mdraid also has the dm-0 entry in "active sync" state. However, I/O to dm-0 would fail since there is no drive underneath, while I/O to dm-1 would succeed.

Now if the failed drive is reinserted, device mapper/multipath would update the dm-0 maps and now dm-0 handles a valid/existing drive. Since mdraid still thinks dm-0 is active sync, I/O continues as if raid0 array was clean.

I haven't tried with other raid levels, but I suspect a similar behavior.

Here are prints in kernel log on drive removal, with drive being part of raid config and without it being part of config

***Removal with dm-X configured as path of md****

Mar  9 17:57:07 ion-ws1lvp4w kernel: [ 2173.868995] mpt2sas0: removing handle(0x0012), sas_addr(0x50011731001395ea)
Mar  9 17:57:07 ion-ws1lvp4w multipathd: sdq: remove path (uevent)
Mar  9 17:57:08 ion-ws1lvp4w multipathd: mpathh: map in use
Mar  9 17:57:08 ion-ws1lvp4w multipathd: mpathh: can't flush
Mar  9 17:57:08 ion-ws1lvp4w multipathd: mpathh: load table [0 3750748848 multipath 0 0 0 0]
Mar  9 17:57:08 ion-ws1lvp4w multipathd: sdq: path removed from map mpathh


***Removal with no configuration***

Mar  9 18:01:32 ion-ws1lvp4w kernel: [ 2438.314508] mpt2sas0: removing handle(0x0012), sas_addr(0x50011731001395ea)
Mar  9 18:01:33 ion-ws1lvp4w multipathd: 65:0: mark as failed
Mar  9 18:01:33 ion-ws1lvp4w multipathd: mpathh: remaining active paths: 0
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.391320] device-mapper: multipath: Failing path 65:0.
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.391336] end_request: I/O error, dev dm-7, sector 3750748672
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.391341] quiet_error: 7 callbacks suppressed
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.391344] Buffer I/O error on device dm-7, logical block 468843584
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.391385] end_request: I/O error, dev dm-7, sector 3750748672
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.391391] Buffer I/O error on device dm-7, logical block 468843584
Mar  9 18:01:33 ion-ws1lvp4w multipathd: sdq: remove path (uevent)
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.395616] end_request: I/O error, dev dm-7, sector 3750748672
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.395619] Buffer I/O error on device dm-7, logical block 468843584
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.395638] end_request: I/O error, dev dm-7, sector 3750748672
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.395640] Buffer I/O error on device dm-7, logical block 468843584
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.396691] end_request: I/O error, dev dm-7, sector 3750748672
Mar  9 18:01:33 ion-ws1lvp4w kernel: [ 2438.396697] Buffer I/O error on device dm-7, logical block 468843584
Mar  9 18:01:33 ion-ws1lvp4w multipathd: mpathh: map flushed
Mar  9 18:01:33 ion-ws1lvp4w multipathd: mpathh: stop event checker thread (140284200109824)
Mar  9 18:01:33 ion-ws1lvp4w multipathd: mpathh: removed map after removing all paths
Mar  9 18:01:33 ion-ws1lvp4w multipathd: mpathh: adding map
Mar  9 18:01:33 ion-ws1lvp4w multipathd: mpathh: devmap dm-7 added
Mar  9 18:01:33 ion-ws1lvp4w multipathd: mpathh: adding map


Ideally the dm-X (multipath device) should be removed so that mdraid updates its constituent drive information. dm-X is not being removed because its in use by raid. Any insight into how we could fix this issue?

Thanks,
Sushma

________________________________

PLEASE NOTE: The information contained in this electronic mail message is intended only for the use of the designated recipient(s) named above. If the reader of this message is not the intended recipient, you are hereby notified that you have received this message in error and that any review, dissemination, distribution, or copying of this message is strictly prohibited. If you have received this communication in error, please notify the sender by telephone or e-mail (as shown above) immediately and destroy any and all copies of this message in your possession (whether hard copies or electronically stored copies).

