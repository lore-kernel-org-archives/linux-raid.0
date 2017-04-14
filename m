From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Linux software raid troubles
Date: Fri, 14 Apr 2017 17:52:43 +0200
Message-ID: <d4c26240-30a1-6e02-bbed-9945a5766034@thelounge.net>
References: <CAAO=44Y=8xrnWvMp214RFq9Y-KVDQVfEYa2vL-Ahgmbvgs6Y4w@mail.gmail.com>
 <8e9a25fc-5c81-103c-2ffa-4b46f2aa8630@thelounge.net>
 <CAAO=44bsG1yrmYbag1eruNA_tdXxqiJptnRyPB=4TW6r5771HQ@mail.gmail.com>
 <cbadbdeb-7e6b-7784-e49c-dd2801903bb6@thelounge.net>
 <CAAO=44Y9YspCqyfvDgx30mGO_VhYZpuj9D8U1O6063B8VL61vw@mail.gmail.com>
 <d1695ac6-5912-860a-0b70-e0d9a322002e@suddenlinkmail.com>
 <CAAO=44YCU+OF-xBytuMCHEtV7WbHE6EVyJ_9ncGmM9VNWcj9MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAO=44YCU+OF-xBytuMCHEtV7WbHE6EVyJ_9ncGmM9VNWcj9MA@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: linuxknight <linuxknight@gmail.com>, "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 14.04.2017 um 17:01 schrieb linuxknight:
> David thanks for this additional follow-up.  I was mistaken about the
> LSI card, it was actually a SiL 3124.  The OS didnt see the raid as
> one drive, so its another one of these fake raid cards.  I did get a
> good image.so Im going to re-os this weekend and use the software raid
> method.
> 
> One last question, is it acceptable to let graphical installers setup
> the software raid for me or should I use one disk and create a raid
> mirror later once the OS is setup?

the machine in front of me as installed 2011 with Fedora 9, is currently 
on Fedora 25 and was installed with Anaconda since it works also as 
desktop - for RAID1 a no-brainer if the installer supports  it (the new 
Fedora and RHEL Anaconda is horrible)

just disable any raid functionality on the mainboard so that the prots 
are pure SATA ports (on HP ProLiant the controller at every reboot 
whines that it is unconfigured when done right)

[root@srv-rhsoft:~]$ cat /proc/mdstat
Personalities : [raid1] [raid10]
md0 : active raid1 sdd1[7] sdc1[4] sda1[6] sdb1[5]
       511988 blocks super 1.0 [4/4] [UUUU]

md2 : active raid10 sdd3[7] sdc3[4] sdb3[5] sda3[6]
       3875222528 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]

md1 : active raid10 sdd2[7] sdc2[4] sda2[6] sdb2[5]
       30716928 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]

unused devices: <none>
[root@srv-rhsoft:~]$ df
Dateisystem    Typ  Größe Benutzt Verf. Verw% Eingehängt auf
/dev/md1       ext4   29G    6,9G   22G   24% /
/dev/md0       ext4  485M     34M  448M    7% /boot
/dev/md2       ext4  3,6T    2,3T  1,3T   64% /mnt/data


> On Fri, Apr 14, 2017 at 12:43 AM, David C. Rankin
> <drankinatty@suddenlinkmail.com> wrote:
>> On 04/12/2017 10:36 AM, linuxknight wrote:
>>> Thank you Reindl, Using your method would I be able to apply this IMG
>>> file to a fresh raid1 mirror and still have it be bootable?
>>>
>>> The reason I ask is I was looking at this guide,
>>> https://www.data-medics.com/forum/how-to-clone-a-hard-drive-with-bad-sectors-using-ddrescue-t133.html
>>> It has a method to transfer drive to drive.  I was thinking I would
>>> create the fresh RAID mirror on the dedicated LSI card, then ddrescue
>>> possibly bad drive to the new raid mirror.  Is this a bad idea?
>>
>> Take the dd advise, but... you initially indicated:
>>
>> <quote>
>> I was moving a server with a raid1 configuration,
>> controlled by a Intel Corporation 82801 SATA RAID Controller
>> </quote>
>>
>> Now you are saying
>>
>> <quote>
>>> It has a method to transfer drive to drive.  I was thinking I would
>>> create the fresh RAID mirror on the dedicated LSI card
>> </quote>
>>
>> Note: the Intel and LSI cards may not have compatible RAID metadata. (That is
>> one of the major benefits of using linux-raid (software RAID) you are not
>> constrained by differing hardware RAID specifications.)
>>
>> You also mention "to a fresh raid1 mirror and still have it be bootable?" If
>> you image the drive with dd, the mbr or bootloader will still be present on in
>> the image and on the drive, so as long as you can tell the OS to boot from
>> that drive you should be fine (as long as the controller can access the
>> information)
>>
>> A good general howto on setting up linux-raid is
>> https://wiki.archlinux.org/index.php/RAID

