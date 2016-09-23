From: Axel Spallek <axel@spallek.org>
Subject: Re: RAID5 grow interrupted.
Date: Fri, 23 Sep 2016 07:23:43 +0200
Message-ID: <85788342-4b87-b6f8-c717-0cf36f1be201@spallek.org>
References: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
 <9c618b69-1e84-60a8-d25c-55171058c855@websitemanagers.com.au>
 <af2cbd12-ba6c-0e39-ba1d-651feda5d07c@spallek.org>
 <20160922194517.GA6019@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160922194517.GA6019@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This one did it, but not the first time I issued this command. Maybe 
--assemble --scan was needed first.

Thanks to all!


root@s10:~# mdadm --assemble /dev/md1 /dev/sd[a-h]1 
--backup-file=/var/backups/mdadm.backup
mdadm: Need to backup 21504K of critical section..
mdadm: /dev/md1 has been started with 8 drives.
root@s10:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active raid5 sdh1[0] sda1[5] sdb1[6] sdc1[7] sdd1[8] sdf1[4] 
sde1[2] sdg1[1]
       23441292288 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[7/7] [UUUUUUU]
       [>....................]  reshape =  4.0% (159293440/3906882048) 
finish=50748595.7min speed=0K/sec

unused devices: <none>

Aksels




Am 22.09.2016 um 21:45 schrieb Andreas Klauer:
> On Thu, Sep 22, 2016 at 08:41:59PM +0200, Axel Spallek wrote:
>> root@s10:~# mdadm --assemble /dev/md1 /dev/sd[a-h]1
>> mdadm: /dev/md1: Need a backup file to complete reshape of this array.
>> mdadm: Please provided one with "--backup-file=..."
> I assume it was assembled anyway at this point so --stop again...
>
>> root@s10:~# mdadm --assemble /dev/md1 /dev/sd[a-h]1
>> --backup-file=/var/backups/mdadm.backup
>> mdadm: /dev/sda1 is busy - skipping
>> mdadm: /dev/sdb1 is busy - skipping
> regards
> Andreas Klauer

-- 

Mit freundlichem Gruß,

Axel Spallek
Dipl.-Ing. FH IE

Hochdorfer Straße 34
88477 Schönebürg

Mobil: 01577 7929886
E-Mail: axel@spallek.org

Bankverbindung:
Volksbank Schwendi
IBAN: DE20654913200095195009
BIC: GENODES1VBL

Steuernummer: 5438000091
UST.-ID.:     DE290536647

