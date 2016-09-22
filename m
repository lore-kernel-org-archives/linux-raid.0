From: Axel Spallek <axel@spallek.org>
Subject: Re: RAID5 grow interrupted.
Date: Thu, 22 Sep 2016 20:59:36 +0200
Message-ID: <0fa1cbf2-a633-29cd-b340-e44395c36da1@spallek.org>
References: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
 <20160922171915.GA5392@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160922171915.GA5392@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 22.09.2016 um 19:19 schrieb Andreas Klauer:
> On Thu, Sep 22, 2016 at 04:11:28PM +0200, Axel Spallek wrote:
>> I tried to get a disk out of a RAID5 with 8 hdds (4TB) to get a Hotspare
>> to change to RAID6 afterwards.
> I'm a bit confused here.
>
> You started out with 8 disk RAID-5? And final result is to be what?
> RAID-6 with 8 disks?
Correct.
>
>> Therefore I issued the following commands:
>>
>> mdadm --grow -n7 /dev/md1  <-- just to get the size for the next command.
>>
>> mdadm --grow /dev/md1 --array-size 23441292288
>>
>> mdadm --grow -n7 /dev/md1 --backup-file /var/backups/mdadm.backup
> I'm not sure, but you might not have needed any of these intermediate steps.
Hmmm. Had RAID5 with 8 disks. To convert to RAID6 you need a Hotspare, 
but all my drive-cage is full.
> But now you started it you might have to finish them.
> That said there is a reshape revert (which is not yet in the manpage?)
> which might help if the regular reshape just won't resume.
Yes. That info would help.
>
>> root@s10:~# mdadm -A --scan --verbose
>> mdadm: looking for devices for further assembly
>> mdadm: /dev/sdg1 is busy - skipping
> It says busy because already assembled (or in use by something else).
> So you have to stop first before assembeling again.
>
> I didn't see anything out of place in your --examine.
> It seems to be in sync, event count identical, ....
>
> Good luck
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

