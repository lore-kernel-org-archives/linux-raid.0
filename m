From: rrk <rrk@prairie.lakes.com>
Subject: Raid1 problem can't add remove or mark faulty -- it did work
Date: Sun, 27 Mar 2005 12:38:29 -0600
Message-ID: <4246FDA5.70107@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
mdstat after reboot

root@crm_svr:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] 
[raid10]
md0 : active raid1 hdc1[1]
      155268096 blocks [2/1] [_U]

unused devices: <none>

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
the below error shows after a boot when excuted in kde konsole

root@crm_svr:/home/rob# mdadm /dev/md0 -a /dev/hda1
mdadm: hot add failed for /dev/hda1: Invalid argument

but this error is shown from a tty console
 
md: could not bd_claim hda1
md: error, md_import_device() returned -16
mdadm: hot add failed for /dev/hda1 : invalid argument

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
this is what shows in dmesg

md: could not bd_claim hda1.
md: error, md_import_device() returned -16
md: could not bd_claim hda1.
md: error, md_import_device() returned -16
md: could not bd_claim hda1.
md: error, md_import_device() returned -16

i had this bd_claim error when i first tried to build the array
but it went away when i wiped every thing and started over
this box is the only time i have seen this error and i
tried using different drives -- but of the same type -- when
the problem  showed up on the initial build



 
