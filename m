From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Sun, 24 Jun 2012 12:15:10 +0000 (UTC)
Message-ID: <js70ce$fgv$1@dough.gmane.org>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>
	<4FE5B213.5010503@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 23 Jun 2012 07:09:55 -0500, Stan Hoeppner wrote:

> On 6/22/2012 9:37 AM, Ramon Hofer wrote:
>> Sorry, I hit the wrong button.On Thu, 21 Jun 2012 22:44:10 +0000, Ramon
>> Hofer wrote:
>> 
>>> Is it possible to start md1 again to be able to start the linear array
>>> md0 so that I can accesss the data?
>> 
>> Stan will probably be angry with me but I did the following:
>> 
>> I found the recovery page in your wiki:
>> https://raid.wiki.kernel.org/index.php/RAID_Recovery
>> 
>> So I followed the process there.
>> This is what I did:
>> 
>> ~$ mdadm --examine /dev/sd[abcd] > raid.status.md1
>> 
>> ~$ mdadm --create --assume-clean -c 128 --level=5 --raid-devices=4
>> /dev/ md1 /dev/sda /dev/sdb /dev/sdc /dev/sdd
>> 
>> It was up and clean.
>> 
>> ~$ mdadm --examine /dev/md[12] > raid.status.md0
>> 
>> ~$ mdadm -C --assume-clean -n2 -l linear /dev/md0 /dev/md[12]
>> 
>> Now I could mount md0 and all my data is still there :-D
> 
> You should have run an "xfs_repair -n" before mounting.  "-n" means no
> modify, making it a check operation.  If it finds errors then rerun it
> without the "-n" so it can make necessary repairs.  Then remount.  Sorry
> I forgot to mention this, or remind you, whichever is the case. :)

Thanks you!

You have mentioned but I forgot to do it.
I did it now and still everything looks good.
At least with the WD blacks and the Samsung drives.

One WD green was again marked faulty when I tried to create an array with 
them.

This is the output of dmesg:
http://pastebin.com/raw.php?i=5aukYJa8

This seems to be not good:
[61142.466334] md/raid:md9: read error not correctable (sector 3758190680 
on sdk).
[61142.466338] md/raid:md9: Disk failure on sdk, disabling device.

What could the reason of this issue be?
Is it because the disk is broken or not suited for raid use?

I'm now running smartctl -t long /dev/sdk.
I have no clue if this helps in any way...

Here's the output of smartctl -a /dev/sdk:
http://pastebin.com/raw.php?i=2ULrx6du


Should I bring the disc to my dealer or is it an issue of using it with 
mdadm?


Best regards
Ramon

