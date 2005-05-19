From: Tyler <pml@dtbb.net>
Subject: Re: Problems setting up RAID1
Date: Thu, 19 May 2005 06:40:36 -0700
Message-ID: <428C9754.8080503@dtbb.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090301060908020405060107"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: George Huber <huber_geo@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090301060908020405060107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I posted this response about 2 weeks ago, for someone trying to do the 
same thing.

Regards,
Tyler.

--------------090301060908020405060107
Content-Type: message/rfc822;
 name="Re: raid 1 with static kernel."
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Re: raid 1 with static kernel."

X-Account-Key: account2
Return-Path: <linux-raid-owner@vger.kernel.org>
Delivered-To: tyler@goliath.digitallyperfect.com
Received: (qmail 27804 invoked by alias); 4 May 2005 15:53:21 -0000
Delivered-To: pml@dtbb.net
Received: (qmail 27800 invoked from network); 4 May 2005 15:53:21 -0000
Received: from vger.kernel.org (12.107.209.244)
  by 0 with SMTP; 4 May 2005 15:53:21 -0000
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S261891AbVEDP4b (ORCPT <rfc822;pml@dtbb.net>);
	Wed, 4 May 2005 11:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S261901AbVEDP4b
	(ORCPT <rfc822;linux-raid-outgoing>); Wed, 4 May 2005 11:56:31 -0400
Received: from outbound05.telus.net ([199.185.220.224]:29856 "EHLO
	priv-edtnes40.telusplanet.net") by vger.kernel.org with ESMTP
	id S261891AbVEDP4U (ORCPT <rfc822;linux-raid@vger.kernel.org>);
	Wed, 4 May 2005 11:56:20 -0400
Received: from [192.168.0.28] (really [142.179.55.145])
          by priv-edtnes40.telusplanet.net
          (InterMail vM.6.01.04.04 201-2131-118-104-20050224) with ESMTP
          id <20050504155619.LKZD17135.priv-edtnes40.telusplanet.net@[192.168.0.28]>;
          Wed, 4 May 2005 09:56:19 -0600
Message-ID: <4278F0A5.60406@dtbb.net>
Date: Wed, 04 May 2005 08:56:21 -0700
From: Tyler <pml@dtbb.net>
User-Agent: Mozilla Thunderbird 1.0.2 (Windows/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Glatzel Tino <tino.glatzel@badenIT.de>, linux-raid@vger.kernel.org
Subject: Re: raid 1 with static kernel.
References: <23ADBF4236843B469BE57F05F135897602E744DB@srvntexc2.swfr>
In-Reply-To: <23ADBF4236843B469BE57F05F135897602E744DB@srvntexc2.swfr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org

Try this howto:

http://www.linuxsa.org.au/mailing-list/2003-07/1270.html

Regards,
Tyler.

Glatzel Tino wrote:

>hello list,
>
>
>my system is a Debian GNU Linux Sarge. The kernelversion is 2.6.10 without
>modulsupport.
>The partion id is  fd.
>In the first step, the complete system is installed on /dev/hda3.
>In the second step, i have created a raid 1 device:
>mdadm --create /dev/md0 --level 1 --raid-device=2 /dev/hda1 /dev/hdc1
>mkfs -t ext3 /dev/md0
>mount /dev/md0 /mnt
>cp -pr /boot /mnt
>umount /mnt
>
>I want to mount /dev/md0 in /boot
>change in the /etc/fstab
>/dev/md0       /boot   ext3    defaults    0      2
>
>
>
>after a reboot, i see the mounted devices:
>
>/dev/hda3 on / type ext3 (rw,errors=remount-ro)
>/dev/md0 on /boot type ext3 (rw)
>
>so, i think i will never need the files in the old /boot directory.
>
>umount /boot
>cd /boot
>ls
>System.map-2.6.8-1-386
>config-2.6.8-1-386      vmlinuz-2.6.10
>grub                    vmlinuz-2.6.10-raid-grsec
>initrd.img-2.6.8-1-386  vmlinuz-2.6.10-raid-grsec-hotplug
>lost+found              vmlinuz-2.6.8-1-386
>System.map-2.6.10
>
>
>
>rm -r *
>cd ..
>mount /boot
>ls /boot
>System.map-2.6.8-1-386
>config-2.6.8-1-386      vmlinuz-2.6.10
>grub                    vmlinuz-2.6.10-raid-grsec
>initrd.img-2.6.8-1-386  vmlinuz-2.6.10-raid-grsec-hotplug
>lost+found              vmlinuz-2.6.8-1-386
>System.map-2.6.10
>
>
>after a reboot, i see the following message from Grub:
>
>GRUB Loading Stage1.5
>
>GRUB loading, please wait ...
>Error 15
>
>
>Ok, i think GRUB can`t access to /dev/md0
>what can i do?
>
>
>Tino
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



--------------090301060908020405060107--
