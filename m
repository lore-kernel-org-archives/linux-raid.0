From: rrk <rrk@prairie.lakes.com>
Subject: Re: Raid1 problem can't add remove or mark faulty -- it did work
Date: Sun, 27 Mar 2005 13:30:29 -0600
Message-ID: <424709D5.5060105@prairie.lakes.com>
References: <200503271903.j2RJ3cT03030@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503271903.j2RJ3cT03030@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:

>I am not sure what bd_claim is, but it is somewhat like open().  My guess is
>your disk is in use, maybe nounted.  Run this command and send the output.
>
>df
>
>Guy
>
>  
>
 yep that was it -- there is a whizzing wizard somewhere it is not 
fstab-- though i checked that
sorry for the trouble and thanks
rob





>  
>
>>-----Original Message-----
>>From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>>owner@vger.kernel.org] On Behalf Of rrk
>>Sent: Sunday, March 27, 2005 1:38 PM
>>To: linux-raid@vger.kernel.org
>>Subject: Raid1 problem can't add remove or mark faulty -- it did work
>>
>>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
>>mdstat after reboot
>>
>>root@crm_svr:~# cat /proc/mdstat
>>Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
>>[raid10]
>>md0 : active raid1 hdc1[1]
>>      155268096 blocks [2/1] [_U]
>>
>>unused devices: <none>
>>
>>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
>>the below error shows after a boot when excuted in kde konsole
>>
>>root@crm_svr:/home/rob# mdadm /dev/md0 -a /dev/hda1
>>mdadm: hot add failed for /dev/hda1: Invalid argument
>>
>>but this error is shown from a tty console
>>
>>md: could not bd_claim hda1
>>md: error, md_import_device() returned -16
>>mdadm: hot add failed for /dev/hda1 : invalid argument
>>
>>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
>>this is what shows in dmesg
>>
>>md: could not bd_claim hda1.
>>md: error, md_import_device() returned -16
>>md: could not bd_claim hda1.
>>md: error, md_import_device() returned -16
>>md: could not bd_claim hda1.
>>md: error, md_import_device() returned -16
>>
>>i had this bd_claim error when i first tried to build the array
>>but it went away when i wiped every thing and started over
>>this box is the only time i have seen this error and i
>>tried using different drives -- but of the same type -- when
>>the problem  showed up on the initial build
>>
>>
>>
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>    
>>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

