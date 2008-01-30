From: Rui Santos <rsantos@grupopie.com>
Subject: Re: Check mdadm-Raid 5
Date: Wed, 30 Jan 2008 10:11:53 +0000
Message-ID: <47A04D69.1060903@grupopie.com>
References: <20080130090744.249790@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080130090744.249790@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Mott wrote:
> Hi there,
>   
Hi,
> you're just my last hope - I think.
>
> I've posted this question at many Web-Sites in the last week, but nobody can help me.
>
> For a view days I've created a Software Raid 5 (mdadm) under Ubuntu 7.10 32Bit Alternate with 4 x 233 GiB SATA II Hdds @ USB 2.0.
>
> After that I want to create a Truecrypt-Volume on this md-Device what not should be a problem.
>
> But the Process hangs after a view Minutes running and then whole System hangs. So I've pushed the Power-Button and the System writes something to the System-Hdd - but then nothing happens further. Then I have resetted the System.
>
> After next boot I've assembled the Raid 5 again what function without any problem. The System even wont to resync anything.
>
> After that I've build the Truecrypt-Volume on the whole md-Device without any Problem. 
>
> Now my question: Is there any Methode to Test the integrity of die md-Device at low-level? Can I trust the Device?
>   

I use this script on a regular basis to check for RAID integrity. I hope 
this is what you mean.

#!/bin/bash

# Check all RAIDs
RAIDS_TO_CHECK="md0 md1 md2"

# Check all md's
for i in $RAIDS_TO_CHECK; do
        echo check >> /sys/block/$i/md/sync_action
        sleep 5
        while ( test `mdadm --misc --detail /dev/$i | grep -c "Rebuild 
Status"` -gt 0 ); do
                sleep 10
        done
        if ( test $(( `cat /sys/block/$i/md/mismatch_cnt` )) -gt 0 ); then
                echo repair >> /sys/block/$i/md/sync_action
                sleep 2
                while ( test `mdadm --misc --detail /dev/$i | grep -c 
"Rebuild Status"` -gt 0 ); do
                        sleep 10
                done
                echo "Warning: A Repair to RAID $i was needed..."
        fi
done

> Best regards,
>
> Michael
>   
Rui


-- 

Cumprimentos

*Rui Santos*
Dep. Testes

*GrupoPIE Portugal, S.A.*
Tel:   +351 252 290 600
Fax:  +351 252 290 601

Email: rsantos@grupopie.com <mailto:rsantos@grupopie.com>
Web: www.grupopie.com <http://www.grupopie.com/>

/WinREST /EVERYWHERE

