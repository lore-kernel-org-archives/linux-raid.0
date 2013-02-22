From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Fri, 22 Feb 2013 17:35:36 -0500
Message-ID: <5127F2B8.4050601@turmel.org>
References: <5123A1CC.2000003@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heis
 l.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5127D857.9090204@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/22/2013 03:43 PM, Stone wrote:
> so hello again.
> the script was running and i looked at my logs.
> 
> this results i have
> with chunk-size 8,16,32,64,128 i have always the same error: Enter
> passphrase for /dev/md2: No key available with this passphrase.
> 
> the first time to open it is possible with chunk 256
> 
> i send you some logs from 256 and 512
> 
> at 512 i get the first results with checksum errors.
> i think the right size is 512?! but the filesystem is brocken?!

Damage near the beginning of your filesystem is expected, remember?
Lots of damage further in is not expected, once we have the right settings.

Very interesting.  Especially this with sdb-sdc-missing-sde:

> The filesystem size (according to the superblock) is 1465134336 blocks
> The physical size of the device is 1465133568 blocks
> Either the superblock or the partition table is likely to be corrupt!
> Abort? no


I think this is the right device order, and the right chunk size.  It
also best matches what we know of your original setup.  But the total
size of the array device is 768 blocks smaller than it should be.  This
should be solved.

Please recreate the array with this combination, then show:

mdadm -D /dev/md2
mdadm -E /dev/sd[bce]1
cat /proc/partitions
for x in /dev/sd[bce] ; do fdisk -l $x ; done

Phil
