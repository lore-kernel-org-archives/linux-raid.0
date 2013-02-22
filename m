From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Fri, 22 Feb 2013 15:58:27 +0100
Message-ID: <51278793.80904@heisl.org>
References: <5123A1CC.2000003@heisl.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heis
 l.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51277876.30008@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 22.02.2013 14:53, schrieb Phil Turmel:
> On 02/22/2013 05:31 AM, stone@heisl.org wrote:
>> to work on the live cd is very slow.
>> i will kick out my two system drives and take one new and install a old
>> system (ubuntu 11.04, i think on this system i have created the first
>> time the raid) to it.
>>
>> do you have new infos from the hexdump or other news to try out some
>> things the get the raid and the luks running?
> Unfortunately, no.  The hexdump had no real superblock candidates that I
> could see.  That strongly suggests that there remain some ordering
> issues.  I would try chunk sizes down to 8k.  If that still doesn't
> work, consider re-creating with a different drive order--it's a slim
> possibility that "sdc1 sdd1 missing sdf1" isn't correct.
>
> Meanwhile, you haven't supplied the complete hexdump of your luks
> signature sector.  It may not help, but it would show the payload offset.
i have installed the system now with one system drive.
the raid devices are now: sdb1 sdc1 sdd1(brocken not sync) sde1

i have now tested all chunk's from 512k to 8k
512 Open Luks but no superblock
256 Open Luks but no superblock
128 No key available with this passphrase
64 No key available with this passphrase
32 No key available with this passphrase
16 No key available with this passphrase
8 No key available with this passphrase

512k and 256k working better...
next tests:
mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5 
--raid-devices=4 /dev/sde1 /dev/sdb1 missing /dev/sdc1
     No Luks
mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5 
--raid-devices=4 /dev/sdc1 /dev/sdb1 missing /dev/sde1
     No Luks
mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5 
--raid-devices=4 /dev/sdc1 missing /dev/sdb1 /dev/sde1
     No Luks
mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5 
--raid-devices=4 /dev/sdb1 /dev/sde1 /dev/sdc1 missing
     fsck.ext4: Invalid argument while trying to open /dev/mapper/md2_nas
     fsck.ext4: Bad magic number in super-block while trying to open 
/dev/mapper/md2_nas
mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5 
--raid-devices=4 /dev/sde1 /dev/sdc1 /dev/sdb1 missing
     No Luks
mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5 
--raid-devices=4 /dev/sdc1 /dev/sde1 /dev/sdb1 missing
     No Luks
mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5 
--raid-devices=4 /dev/sdb1 /dev/sdc1 /dev/sde1 missing
     fsck.ext4: Invalid argument while trying to open /dev/mapper/md2_nas
     fsck.ext4: Bad magic number in super-block while trying to open 
/dev/mapper/md2_nas

do you think that i should try do mount the partion as RO? but i think 
this is not working because the damaged filesystem. right?
>> thank you.
> You're welcome, for what it's worth.  The encryption layer has stymied
> my normal tricks for figuring out how an array was put together.
>
> Phil

