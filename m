From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 1 needs repair
Date: Thu, 4 Feb 2016 16:30:57 -0500
Message-ID: <56B3C311.5060407@turmel.org>
References: <285536573.454192.1454595669809.JavaMail.open-xchange@app01.ox.hosteurope.de>
 <56B36577.2030902@turmel.org>
 <1161942166.457494.1454601803851.JavaMail.open-xchange@app01.ox.hosteurope.de>
 <56B38012.5020404@turmel.org>
 <43098506.459602.1454607669214.JavaMail.open-xchange@app01.ox.hosteurope.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43098506.459602.1454607669214.JavaMail.open-xchange@app01.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Lamby <webmaster@peter-speer.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/04/2016 12:41 PM, Stefan Lamby wrote:
> 
>> You may also need "mdadm --zero-superblock /dev/sda1" before the add
>> command.
>>
>> But if it's currently active in the array, why do you need to fail it?
> 
> So this is the right way?
> 
> mdadm --manage /dev/md0 --remove /dev/sda1 # remove failed disk from array
> mdadm --zero-superblock /dev/sda1
> mdadm --manage /dev/md0 --add /dev/sda1 # add new disk to array (assumed same or
> greater space for partition)

Your mdstat and your lsdrv output disagree on the status of /dev/sdb1.
If mdstat is current, what belongs to what?  Your --examine results
suggest sda1 and sdb1 go together, but mdstat shows sdc1 running with
sdb1 in another array and sda1 all alone.  If sda1 is all alone in an
array you can't remove it.

Your device names are probably changing between boots (not unusual) and
it is confusing your report.

Please show lsdrv results after you add the proper utilities to the
environment you run lsdrv from.  At least install lvm utilities and
mdadm utilities.

Phil
