Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FBBC43334
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 21:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbiFHVhE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 17:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiFHVhE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 17:37:04 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9C63E5DB
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 14:37:02 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 82C885C0156
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 17:37:01 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute4.internal (MEProxy); Wed, 08 Jun 2022 17:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=braithwaite.dev;
         h=cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1654724221; x=1654810621; bh=MCBtQrqxQT
        qHd+jn8efFXHtJGIAtcndLr+W1Z2QtWAc=; b=vmQpf4Tek/T00Brm3+EoYe/QnW
        +Z288xesetAdrlBWXRad3/CF9pcoo2PDIFzSqse3KIIvJOlugcP46tZA5LpGj3+q
        I2XTn2SndQHw9g/PQmaAbl1gXtiO3qhBv1SQfobAB7Ck5dJrTfrOmmmSd3eMWqW3
        xNMYgkAJ2CS3P8fiFT8TgH7HXnBLXn/l/BuqFPHj3OdQre9v0wUN6SnR32lrUAgJ
        0MpCj1JFPgSv+5brtCs1XEQACdSOHI+XLfBHDnzpb8lcYNT9AinDzwDuiZk0KLBX
        amUa2zSpwG1mUPDRWNe/81hjSTsOGv27erxbQu6YyzYu5swHfoNMEXJJMmMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:date:feedback-id:feedback-id:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1654724221; x=1654810621; bh=MCBtQrqxQTqHd+jn8efFXHtJGIAt
        cndLr+W1Z2QtWAc=; b=Q/joZoL/KkjtbDJKY/OAz5AbOoMdzFqTBfcXtany668k
        Lr3ngG0T9BcM+TyStbuzou36bxJJMUnfwNE9kJAdPo12E5PSYaw4u6EvrPT3RI6M
        QpdQ6vJnTNy9h0EyZ6Ldi/6emA4HOudmXuRPCGYnYlBeqDtlUy9Cw6rKQ4VwOm09
        U+yRPBQL/qTBq9aBFV0LDdFS3HrmJM09EFY+7espccw1rg+74d+kOZS4c8U4UArd
        TJt6Bm9f6BwRc9h0Al8dTaxnHaR1eFWljEKHGoQmjCzg/XXK7B6rgEWZje0TZpKg
        ZBCpvk5HD1nzIxDNonlI0KllZiV/JCLDJVDrHURo6A==
X-ME-Sender: <xms:fRahYq_hids1ncs14xaTmSE7TiPAkF4W2NGARPOzLAG2Ex6SGlwXLA>
    <xme:fRahYqttwnGUsKHswR4g2NlRIuss_XTA7hgxcYFR38MEPKQWg7-7DlNP_GC3um0X7
    2Qd-ywntzkren6PUsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddtkecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvffutgfgsehtqhertderre
    ejnecuhfhrohhmpedftehlrghnuceurhgrihhthhifrghithgvfdcuoegrlhgrnhessghr
    rghithhhfigrihhtvgdruggvvheqnecuggftrfgrthhtvghrnhepgeetgfduudekhfduhf
    eiffdtiefhtefhgedvveejjefhfeduvdeltdeitdeulefgnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlrghnsegsrhgrihhthhifrghith
    gvrdguvghv
X-ME-Proxy: <xmx:fRahYgCsVHlLE_ZfHWvfbxqdumT_Kd2OHFonCggiOS6uOyCFUHdAVg>
    <xmx:fRahYieoeJDlSo4ZjSFIvALkVgnFJyRNwBoaBwGkiMkHY7YljcMgPA>
    <xmx:fRahYvNmqvzdt0lmR2T-VFTyECITipZkhJcfuvA5RCPdkaI7_Prd7A>
    <xmx:fRahYlYzjcvzzUAMP2I4T0ntA5CfzABhMLqgP-TlZOCU-3jA_cZaKA>
Feedback-ID: i1a914699:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 4724815A0080; Wed,  8 Jun 2022 17:37:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-692-gb287c361f5-fm-20220603.003-gb287c361
Mime-Version: 1.0
Message-Id: <0fa973c1-2961-4f8f-99fa-b427a5c694fd@www.fastmail.com>
Date:   Wed, 08 Jun 2022 14:36:40 -0700
From:   "Alan Braithwaite" <alan@braithwaite.dev>
To:     linux-raid@vger.kernel.org
Subject: MD Array Unexpected Kernel Hang 
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Forgive me if this is the wrong place to ask for help on this issue.  I'=
ve scoured the internet for more tools to debug these arrays and came up=
 short.

=EF=BB=BFI'm afraid I may have done something wrong and gotten my linux =
md raid array into a weird state (can't re-add a failed device).  First,=
 it started with a disk failure.

First some initial context: The array is a non-root partition 5-device r=
aid6 array in a VM using drives passed into the vm via virtio.  Host dri=
ves are a JBOD array connected to an LSI HBA.  I do not pass through the=
 LSI controller PCI device to the VM for simplicity sake.  I'm not sure =
if that's relevant, but the point is there's another layer of indirectio=
n if it matters.

I observed the disk failure via kernel tasks getting hung reading/writin=
g to disk, despite all disks being reported as healthy via smartmontools=
 on both the host and the guest.  Smartmon tests were fine also (as far =
as I can tell, a few slow reads but nothing crazy).

I couldn't unmount the disk or stop the array properly with `mdadm =E2=80=
=94stop /dev/md127`as both commands would hang indefinitely and the md_r=
aid6 kernel task was also in the `D` uninterruptable sleep state.  No th=
reads on the host machine were blocked on IO during this time.  I tried =
a normal shutdown of the VM, but when that hung indefinitely also (waite=
d an hour), I forced the shut down of the machine.

I brought it back up briefly to verify that there was still an issue and=
 had the same results.  I was able to start and mount the array (ext4 fs=
 on top).  However I was unable to read it or unmount it.   I then force=
fully brought the machine back down again.

I took a wild guess and replaced the first drive in the array which also=
 showed the highest read errors corrected by ECC according to smartmon (=
approx 300k over 470TiB processed).  Fortunately, the array came online =
and was mountable/readable again.  I repaced it with a spare drive I had=
 by adding a new disk in KVM and putting at the same mount point `/dev/v=
db`.  I added that drive to the array via: `sfdisk -d /dev/vdc | sfdisk =
/dev/vdb`.  Then `mdadm --manage /dev/md127 --add /dev/vdb1`.

After the sync finished, that drive worked for a few days until I went t=
o reboot the machine for updates again at which point the system hung at=
 shutdown again failing to unmount the array.

So I go through the same process to replace the drive with yet another d=
rive.  This time I tried rebooting immediately after the sync/recovery f=
inished for the newly added drive.  Lo and behold, this one hung too.  W=
hat are the chances that 3 drives failed at almost the same exact time?

Mounting the array with the 4 disks not in that first position works for=
 mounting the array readonly at least (I have not tried read/write yet).

How do I go about debugging this?  The `mdadm =E2=80=94examine` command =
reports `State: clean` for every drive.  Checksums are correct. Everythi=
ng looks fine from the tools I can see.  There were no useful md logs in=
 dmesg, aside from the hung task backtrace (below).

I know that detecting disk failures can be tricky (particularly if they'=
re not throwing errors), but I also don't expect md arrays to completely=
 hang when trying to safely abort usage.

Below are the details of my setup.

Please let me know how I can go about debugging this and recovering the =
full array?  What should I do from here?  It feels like a software issue=
 since I'm not able to see any other errors via other tools and the "fau=
lty" disks read fine from the host (haven't tried writing to them).

Please let me know if there's any more information I can provide.

Thanks,
- Alan

## Host Details

Hardware Details:

```
BIOS Information
        Vendor: American Megatrends Inc.
        Version: 3.3
        Release Date: 07/19/2018
        Address: 0xF0000
        Runtime Size: 64 kB
        ROM Size: 12 MB
        BIOS Revision: 4.6

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: Supermicro
        Product Name: X9DRT
        Version: 0123456789
        Serial Number: 0123456789
        UUID: 00000000-0000-0000-0000-002590a29e98
        Wake-up Type: Power Switch
        SKU Number: To be filled by O.E.M.
        Family: To be filled by O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
        Manufacturer: Supermicro
        Product Name: X9DRT
        Version: 1.21
        Serial Number: ZM2AU38792
        Asset Tag: To be filled by O.E.M.
        Features:
                Board is a hosting board
                Board is replaceable
        Location In Chassis: To be filled by O.E.M.
        Chassis Handle: 0x0003
        Type: Motherboard
        Contained Object Handles: 0

Handle 0x0004, DMI type 4, 42 bytes
Processor Information
        Socket Designation: SOCKET 0
        Type: Central Processor
        Family: Xeon
        Manufacturer: Intel
        ID: E4 06 03 00 FF FB EB BF
        Signature: Type 0, Family 6, Model 62, Stepping 4
```

Host HBA device:

```
LSI 9200-8e 6Gbps 8-lane external SAS HBA P20 IT Mode
```

Arch Linux on Host

```
[abraithwaite@ceres ~]$ uname -a
Linux ceres 5.17.9-arch1-1 #1 SMP PREEMPT Wed, 18 May 2022 17:30:11 +000=
0 x86_64 GNU/Linux
[abraithwaite@ceres ~]$ pacman -Q | grep -i libvirt
libvirt 1:8.3.0-1
[abraithwaite@ceres ~]$ pacman -Q | grep -i qemu-common
qemu-common 7.0.0-10
```

Host storage details

```
sudo dmesg | grep -i lsi
[    1.862556] mpt2sas_cm0: LSISAS2008: FWVersion(20.00.07.00), ChipRevi=
sion(0x03), BiosVersion(00.00.00.00)
[    3.419509] scsi 7:0:9:0: Enclosure         LSI CORP SAS2X36         =
 0718 PQ: 0 ANSI: 5
[abraithwaite@ceres ~]$ sudo dmesg | grep -E '(lsi|sas|scsi)'
[    3.379175] mpt2sas_cm0: hba_port entry: 00000000e975d737, port: 255 =
is added to hba_port list
[    3.384029] mpt2sas_cm0: host_add: handle(0x0001), sas_addr(0x500605b=
0044145d0), phys(8)
[    3.386017] mpt2sas_cm0: expander_add: handle(0x0009), parent(0x0001)=
, sas_addr(0x50030480003954bf), phys(38)
[    3.386589]  expander-7:0: add: handle(0x0009), sas_addr(0x5003048000=
3954bf)
[    3.397307] mpt2sas_cm0: handle(0xa) sas_address(0x5000cca06d2807be) =
port_type(0x1)
[    3.398416] scsi 7:0:0:0: Direct-Access     HGST     HUS724020ALS640 =
 A1C4 PQ: 0 ANSI: 6
[    3.398427] scsi 7:0:0:0: SSP: handle(0x000a), sas_addr(0x5000cca06d2=
807be), phy(8), device_name(0x5000cca06d2807be)
[    3.398431] scsi 7:0:0:0: enclosure logical id (0x500304800039543f), =
slot(0)
[    3.398438] scsi 7:0:0:0: qdepth(254), tagged(1), scsi_level(7), cmd_=
que(1)
[    3.398676] scsi 7:0:0:0: Power-on or device reset occurred
[    3.399879]  end_device-7:0:0: add: handle(0x000a), sas_addr(0x5000cc=
a06d2807be)
[    3.400117] mpt2sas_cm0: handle(0xb) sas_address(0x5000cca06d2927fe) =
port_type(0x1)
[    3.400901] scsi 7:0:1:0: Direct-Access     HGST     HUS724020ALS640 =
 A1C4 PQ: 0 ANSI: 6
[    3.400906] scsi 7:0:1:0: SSP: handle(0x000b), sas_addr(0x5000cca06d2=
927fe), phy(9), device_name(0x5000cca06d2927fe)
[    3.400907] scsi 7:0:1:0: enclosure logical id (0x500304800039543f), =
slot(1)
[    3.400911] scsi 7:0:1:0: qdepth(254), tagged(1), scsi_level(7), cmd_=
que(1)
[    3.401085] scsi 7:0:1:0: Power-on or device reset occurred
[    3.402223]  end_device-7:0:1: add: handle(0x000b), sas_addr(0x5000cc=
a06d2927fe)
[    3.402454] mpt2sas_cm0: handle(0xc) sas_address(0x5000cca06d2924f2) =
port_type(0x1)
[    3.403399] scsi 7:0:2:0: Direct-Access     HGST     HUS724020ALS640 =
 A1C4 PQ: 0 ANSI: 6
[    3.403404] scsi 7:0:2:0: SSP: handle(0x000c), sas_addr(0x5000cca06d2=
924f2), phy(10), device_name(0x5000cca06d2924f2)
[    3.403406] scsi 7:0:2:0: enclosure logical id (0x500304800039543f), =
slot(2)
[    3.403410] scsi 7:0:2:0: qdepth(254), tagged(1), scsi_level(7), cmd_=
que(1)
[    3.403586] scsi 7:0:2:0: Power-on or device reset occurred
[    3.404672]  end_device-7:0:2: add: handle(0x000c), sas_addr(0x5000cc=
a06d2924f2)
[    3.404915] mpt2sas_cm0: handle(0xd) sas_address(0x5000cca06d283b0a) =
port_type(0x1)
[    3.405667] scsi 7:0:3:0: Direct-Access     HGST     HUS724020ALS640 =
 A1C4 PQ: 0 ANSI: 6
[    3.405672] scsi 7:0:3:0: SSP: handle(0x000d), sas_addr(0x5000cca06d2=
83b0a), phy(11), device_name(0x5000cca06d283b0a)
[    3.405674] scsi 7:0:3:0: enclosure logical id (0x500304800039543f), =
slot(3)
[    3.405678] scsi 7:0:3:0: qdepth(254), tagged(1), scsi_level(7), cmd_=
que(1)
[    3.405855] scsi 7:0:3:0: Power-on or device reset occurred
[    3.406944]  end_device-7:0:3: add: handle(0x000d), sas_addr(0x5000cc=
a06d283b0a)
[    3.407182] mpt2sas_cm0: handle(0xe) sas_address(0x5000cca0284dc06a) =
port_type(0x1)
[    3.407901] scsi 7:0:4:0: Direct-Access     HGST     HUS724020ALS640 =
 A2C0 PQ: 0 ANSI: 6
[    3.407906] scsi 7:0:4:0: SSP: handle(0x000e), sas_addr(0x5000cca0284=
dc06a), phy(12), device_name(0x5000cca0284dc06a)
[    3.407908] scsi 7:0:4:0: enclosure logical id (0x500304800039543f), =
slot(4)
[    3.407912] scsi 7:0:4:0: qdepth(254), tagged(1), scsi_level(7), cmd_=
que(1)
[    3.408088] scsi 7:0:4:0: Power-on or device reset occurred
[    3.409221]  end_device-7:0:4: add: handle(0x000e), sas_addr(0x5000cc=
a0284dc06a)
[    3.409465] mpt2sas_cm0: handle(0xf) sas_address(0x5000cca06d287592) =
port_type(0x1)
[    3.410156] scsi 7:0:5:0: Direct-Access     HGST     HUS724020ALS640 =
 A1C4 PQ: 0 ANSI: 6
[    3.410161] scsi 7:0:5:0: SSP: handle(0x000f), sas_addr(0x5000cca06d2=
87592), phy(14), device_name(0x5000cca06d287592)
[    3.410162] scsi 7:0:5:0: enclosure logical id (0x500304800039543f), =
slot(6)
[    3.410166] scsi 7:0:5:0: qdepth(254), tagged(1), scsi_level(7), cmd_=
que(1)
[    3.410342] scsi 7:0:5:0: Power-on or device reset occurred
[    3.411402]  end_device-7:0:5: add: handle(0x000f), sas_addr(0x5000cc=
a06d287592)
[    3.411643] mpt2sas_cm0: handle(0x10) sas_address(0x5000cca06d3da1be)=
 port_type(0x1)
[    3.412464] scsi 7:0:6:0: Direct-Access     HGST     HUS724020ALS640 =
 A2C0 PQ: 0 ANSI: 6
[    3.412469] scsi 7:0:6:0: SSP: handle(0x0010), sas_addr(0x5000cca06d3=
da1be), phy(15), device_name(0x5000cca06d3da1be)
[    3.412471] scsi 7:0:6:0: enclosure logical id (0x500304800039543f), =
slot(7)
[    3.412474] scsi 7:0:6:0: qdepth(254), tagged(1), scsi_level(7), cmd_=
que(1)
[    3.412669] scsi 7:0:6:0: Power-on or device reset occurred
[    3.413767]  end_device-7:0:6: add: handle(0x0010), sas_addr(0x5000cc=
a06d3da1be)
[    3.413997] mpt2sas_cm0: handle(0x11) sas_address(0x5000cca06d2919ee)=
 port_type(0x1)
[    3.414669] scsi 7:0:7:0: Direct-Access     HGST     HUS724020ALS640 =
 A1C4 PQ: 0 ANSI: 6
[    3.414674] scsi 7:0:7:0: SSP: handle(0x0011), sas_addr(0x5000cca06d2=
919ee), phy(18), device_name(0x5000cca06d2919ee)
[    3.414676] scsi 7:0:7:0: enclosure logical id (0x500304800039543f), =
slot(10)
[    3.414679] scsi 7:0:7:0: qdepth(254), tagged(1), scsi_level(7), cmd_=
que(1)
[    3.414855] scsi 7:0:7:0: Power-on or device reset occurred
[    3.415859]  end_device-7:0:7: add: handle(0x0011), sas_addr(0x5000cc=
a06d2919ee)
[    3.416099] mpt2sas_cm0: handle(0x12) sas_address(0x5000cca06d28092a)=
 port_type(0x1)
[    3.416734] scsi 7:0:8:0: Direct-Access     HGST     HUS724020ALS640 =
 A1C4 PQ: 0 ANSI: 6
[    3.416739] scsi 7:0:8:0: SSP: handle(0x0012), sas_addr(0x5000cca06d2=
8092a), phy(19), device_name(0x5000cca06d28092a)
[    3.416741] scsi 7:0:8:0: enclosure logical id (0x500304800039543f), =
slot(11)
[    3.416744] scsi 7:0:8:0: qdepth(254), tagged(1), scsi_level(7), cmd_=
que(1)
[    3.416921] scsi 7:0:8:0: Power-on or device reset occurred
[    3.418104]  end_device-7:0:8: add: handle(0x0012), sas_addr(0x5000cc=
a06d28092a)
[    3.418734] mpt2sas_cm0: handle(0x13) sas_address(0x50030480003954bd)=
 port_type(0x1)
[    3.419509] scsi 7:0:9:0: Enclosure         LSI CORP SAS2X36         =
 0718 PQ: 0 ANSI: 5
[    3.419514] scsi 7:0:9:0: set ignore_delay_remove for handle(0x0013)
[    3.419516] scsi 7:0:9:0: SES: handle(0x0013), sas_addr(0x50030480003=
954bd), phy(36), device_name(0x50030480003954bd)
[    3.419518] scsi 7:0:9:0: enclosure logical id (0x500304800039543f), =
slot(28)
[    3.419521] scsi 7:0:9:0: qdepth(254), tagged(1), scsi_level(6), cmd_=
que(1)
[    3.419642] scsi 7:0:9:0: Power-on or device reset occurred
[    3.421412]  end_device-7:0:9: add: handle(0x0013), sas_addr(0x500304=
80003954bd)
[    9.644938] mpt2sas_cm0: port enable: SUCCESS
```

Passing through SAS drives to guest in KVM via this kind of libvirt conf=
iguration:

```
<disk type=3D"block" device=3D"disk">
  <driver name=3D"qemu" type=3D"raw" cache=3D"none" io=3D"native"/>
  <source dev=3D"/dev/sdh1" index=3D"7"/>
  <backingStore/>
  <target dev=3D"vdb" bus=3D"virtio"/>
  <alias name=3D"virtio-disk1"/>
  <address type=3D"pci" domain=3D"0x0000" bus=3D"0x08" slot=3D"0x00" fun=
ction=3D"0x0"/>
</disk>
```

Host disks are formatted as such:

```
sudo fdisk -l /dev/sdb
Disk /dev/sdb: 1.82 TiB, 2000398934016 bytes, 3907029168 sectors
Disk model: HUS724020ALS640
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xaa654211

Device     Boot Start        End    Sectors  Size Id Type
/dev/sdb1        2048 3907029167 3907027120  1.8T 83 Linux
```

## Guest Details

Arch Linux Guest, recently updated the kernel (saw some patches in 5.18.=
2 that made me hopeful, but alas I'm still having the issue).

```
[root@arch arch]# uname -a
Linux arch 5.18.2-arch1-1 #1 SMP PREEMPT_DYNAMIC Mon, 06 Jun 2022 19:58:=
58 +0000 x86_64 GNU/Linux
```

Bad disk (currently out of the array):

```
mdadm --examine /dev/vdb1
/dev/vdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 238d6359:a2f569cb:7cc48d36:43ba9632
           Name : arch:jbod  (local to host arch)
  Creation Time : Sat Dec  4 18:34:57 2021
     Raid Level : raid6
   Raid Devices : 5

Avail Dev Size : 3906760847 sectors (1862.89 GiB 2000.26 GB)
     Array Size : 5860141056 KiB (5.46 TiB 6.00 TB)
  Used Dev Size : 3906760704 sectors (1862.89 GiB 2000.26 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D264112 sectors, after=3D143 sectors
          State : clean
    Device UUID : 5a1d61a1:a95d4a05:0e5a9337:d6f76dbb

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jun  8 12:36:41 2022
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : 3eab5336 - correct
         Events : 19946

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 0
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
```

Good disk:

```
mdadm --examine /dev/vdc1
/dev/vdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 238d6359:a2f569cb:7cc48d36:43ba9632
           Name : arch:jbod  (local to host arch)
  Creation Time : Sat Dec  4 18:34:57 2021
     Raid Level : raid6
   Raid Devices : 5

Avail Dev Size : 3906760847 sectors (1862.89 GiB 2000.26 GB)
     Array Size : 5860141056 KiB (5.46 TiB 6.00 TB)
  Used Dev Size : 3906760704 sectors (1862.89 GiB 2000.26 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D264112 sectors, after=3D143 sectors
          State : clean
    Device UUID : d2857c0f:dcd8b710:101dfb14:6b3f7ff5

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jun  8 14:08:50 2022
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : cfae5712 - correct
         Events : 19954

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 1
   Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
```

Dmesg hang:

```
Jun 05 13:24:17 arch kernel: INFO: task kworker/0:2:258 blocked for more=
 than 122 seconds.
Jun 05 13:24:17 arch kernel:       Not tainted 5.18.1-arch1-1 #1
Jun 05 13:24:17 arch kernel: "echo 0 > /proc/sys/kernel/hung_task_timeou=
t_secs" disables this message.
Jun 05 13:24:17 arch kernel: task:kworker/0:2     state:D stack:    0 pi=
d:  258 ppid:     2 flags:0x00004000
Jun 05 13:24:17 arch kernel: Workqueue: md submit_flushes [md_mod]
Jun 05 13:24:17 arch kernel: Call Trace:
Jun 05 13:24:17 arch kernel:  <TASK>
Jun 05 13:24:17 arch kernel:  ? wbt_done+0xb0/0xb0
Jun 05 13:24:17 arch kernel:  __schedule+0x37c/0x11f0
Jun 05 13:24:17 arch kernel:  ? check_preempt_wakeup+0x28b/0x2a0
Jun 05 13:24:17 arch kernel:  ? rwb_trace_step+0x80/0x80
Jun 05 13:24:17 arch kernel:  ? wbt_done+0xb0/0xb0
Jun 05 13:24:17 arch kernel:  schedule+0x4f/0xb0
Jun 05 13:24:17 arch kernel:  io_schedule+0x46/0x70
Jun 05 13:24:17 arch kernel:  rq_qos_wait+0xc0/0x130
Jun 05 13:24:17 arch kernel:  ? karma_partition+0x280/0x280
Jun 05 13:24:17 arch kernel:  ? rwb_trace_step+0x80/0x80
Jun 05 13:24:17 arch kernel:  wbt_wait+0xa6/0x110
Jun 05 13:24:17 arch kernel:  __rq_qos_throttle+0x27/0x40
Jun 05 13:24:17 arch kernel:  blk_mq_submit_bio+0x3c4/0x640
Jun 05 13:24:17 arch kernel:  __submit_bio+0xf2/0x180
Jun 05 13:24:17 arch kernel:  submit_bio_noacct_nocheck+0x20b/0x2c0
Jun 05 13:24:17 arch kernel:  submit_flushes+0xd8/0x150 [md_mod 728f525e=
20ac2cfceb893dc85f8d68d92d31c960]
Jun 05 13:24:17 arch kernel:  process_one_work+0x1c7/0x380
Jun 05 13:24:17 arch kernel:  worker_thread+0x51/0x380
Jun 05 13:24:17 arch kernel:  ? rescuer_thread+0x3a0/0x3a0
Jun 05 13:24:17 arch kernel:  kthread+0xde/0x110
Jun 05 13:24:17 arch kernel:  ? kthread_complete_and_exit+0x20/0x20
Jun 05 13:24:17 arch kernel:  ret_from_fork+0x22/0x30
Jun 05 13:24:17 arch kernel:  </TASK>
```

5.18.2 dmesg changes slightly:

```
Jun 08 12:48:50 arch kernel: INFO: task md127_raid6:420 blocked for more=
 than 614 seconds.
Jun 08 12:48:50 arch kernel:       Tainted: P           OE     5.18.2-ar=
ch1-1 #1
Jun 08 12:48:50 arch kernel: "echo 0 > /proc/sys/kernel/hung_task_timeou=
t_secs" disables this message.
Jun 08 12:48:50 arch kernel: task:md127_raid6     state:D stack:    0 pi=
d:  420 ppid:     2 flags:0x00004000
Jun 08 12:48:50 arch kernel: Call Trace:
Jun 08 12:48:50 arch kernel:  <TASK>
Jun 08 12:48:50 arch kernel:  __schedule+0x37c/0x11f0
Jun 08 12:48:50 arch kernel:  ? __slab_free+0xe0/0x310
Jun 08 12:48:50 arch kernel:  schedule+0x4f/0xb0
Jun 08 12:48:50 arch kernel:  md_super_wait+0x9f/0xd0 [md_mod afcab5f485=
650b4a150ec4b265d57c09e8217b2a]
Jun 08 12:48:50 arch kernel:  ? cpuacct_percpu_seq_show+0x20/0x20
Jun 08 12:48:50 arch kernel:  md_bitmap_daemon_work+0x213/0x3a0 [md_mod =
afcab5f485650b4a150ec4b265d57c09e8217b2a]
Jun 08 12:48:50 arch kernel:  md_check_recovery+0x47/0x5a0 [md_mod afcab=
5f485650b4a150ec4b265d57c09e8217b2a]
Jun 08 12:48:50 arch kernel:  raid5d+0x8d/0x680 [raid456 a9c4e3a091d6fc6=
eff1c917206c669e086d59fa9]
Jun 08 12:48:50 arch kernel:  ? lock_timer_base+0x61/0x80
Jun 08 12:48:50 arch kernel:  ? md_set_read_only+0x90/0x90 [md_mod afcab=
5f485650b4a150ec4b265d57c09e8217b2a]
Jun 08 12:48:50 arch kernel:  ? del_timer_sync+0x73/0xb0
Jun 08 12:48:50 arch kernel:  ? md_set_read_only+0x90/0x90 [md_mod afcab=
5f485650b4a150ec4b265d57c09e8217b2a]
Jun 08 12:48:50 arch kernel:  md_thread+0xad/0x190 [md_mod afcab5f485650=
b4a150ec4b265d57c09e8217b2a]
Jun 08 12:48:50 arch kernel:  ? cpuacct_percpu_seq_show+0x20/0x20
Jun 08 12:48:50 arch kernel:  kthread+0xde/0x110
Jun 08 12:48:50 arch kernel:  ? kthread_complete_and_exit+0x20/0x20
Jun 08 12:48:50 arch kernel:  ret_from_fork+0x22/0x30
Jun 08 12:48:50 arch kernel:  </TASK>
```

Now tainted because I installed zfs drivers, since that's my next option=
.
