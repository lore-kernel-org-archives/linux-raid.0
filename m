From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: e2fsck  + RAID-5 disk fail test question
Date: Mon, 14 Dec 2009 15:09:22 -0800
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C087E791D@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7906@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7906@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To be more specific. Is it ok to see error during e2fcsk test after the
disk forced to fail in RAID-5.
Regards,
Marri

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tirumala Reddy
Marri
Sent: Monday, December 14, 2009 2:44 PM
To: linux-raid@vger.kernel.org
Subject: e2fsck question


All,
  My question is , after disk force to fail in RAID-5 is it ok to see
i-node errors during e2fsck check to see if there are errors and fix
them ?  

Here is in detail what I did.
  I have RAID-5 setup with 4 drives. This using PowerPC based SOC with
XOR acceleration. I was testing the RAID-5 disk fail test using "mdadm
-f /dev/sda /dev/md0".  I installed Ext-3 file system on /dev/md0 then
ran a "dd" command to do the traffic test. Then I fail the driver. After
few seconds I unmounted the drive and ran "e2fsck -c /dev/md0" to check
the consistency.  I see there e2fcsk complains that there is some
insistency in inodes, block etc and they it says it is correcting it. 


If there are file system inconsistencies and got repaired, you think
there is problem with my setup ?

Thanks and Regards,
Marri
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
