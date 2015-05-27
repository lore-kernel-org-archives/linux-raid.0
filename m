From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Which physical device failed?
Date: Wed, 27 May 2015 18:48:35 +0100
Message-ID: <55660373.3030700@youngman.org.uk>
References: <5565B2BB.5090701@gmail.com>	<5565B41B.8040104@aei.mpg.de> <20150527172701.1090e525@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150527172701.1090e525@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: Michael Munger <michael.munger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/05/15 13:27, Roman Mamedov wrote:
> On Wed, 27 May 2015 14:10:03 +0200 Carsten Aulbert
> <Carsten.Aulbert@aei.mpg.de> wrote:
> 
>> On 05/27/2015 02:04 PM, Michael Munger wrote:
>>> Or, does the OS have access to serial numbers, etc...?
>>> 
>>> I have to guide someone through a drive replacement on the
>>> phone, and it would be great if I could tell them exactly which
>>> drive to swap out...
>> 
>> If you have direct knowledge, which serial number is where, you
>> could use hdparm -I /dev/sdX or smartctl -a /dev/sdX against the
>> still reachable drives.
> 
> If /dev/sdc is still present in the system (even if not responding
> correctly to hdparm or smartctl anymore), you should be able to
> find its serial number from the udev symlink that was registered
> earlier, by running e.g.:
> 
> ls -la /dev/disk/by-id/ | grep sdc$
> 
> Serial number is typically the last piece of the ID, after the
> manufacturer name and model number.
> 
Just for info, I've done an ls -al on my by-id directory, and I have
no clue whatsoever as to what the serial number is. All my drives
appear twice (Seagate Barracudas), there is no manufacturer name that
I can see, and while the model number appears in one of the records,
there is nothing obvious to indicate whether what follows is the
serial number or whether the serial number is part of the other
directory entry.

Not helped, of course, by the fact I have no clue what the serial
number looks like ... :-)

ashdown by-id # ls -la
total 0
drwxr-xr-x 2 root root 620 May 27 08:10 .
drwxr-xr-x 7 root root 140 May 27 08:10 ..
lrwxrwxrwx 1 root root   9 May 27 08:10 ata-Optiarc_DVD_RW_AD-7241S ->
../../sr0
lrwxrwxrwx 1 root root   9 May 27 08:10
ata-ST3000DM001-1CH166_W1F4JWRP -> ../../sdb
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F4JWRP-part1 -> ../../sdb1
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F4JWRP-part2 -> ../../sdb2
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F4JWRP-part3 -> ../../sdb3
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F4JWRP-part4 -> ../../sdb4
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F4JWRP-part5 -> ../../sdb5
lrwxrwxrwx 1 root root   9 May 27 08:10
ata-ST3000DM001-1CH166_W1F50K0F -> ../../sda
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F50K0F-part1 -> ../../sda1
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F50K0F-part2 -> ../../sda2
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F50K0F-part3 -> ../../sda3
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F50K0F-part4 -> ../../sda4
lrwxrwxrwx 1 root root  10 May 27 08:10
ata-ST3000DM001-1CH166_W1F50K0F-part5 -> ../../sda5
lrwxrwxrwx 1 root root  11 May 27 08:10 md-name-ashdown:0 -> ../../md126
lrwxrwxrwx 1 root root  11 May 27 08:10
md-uuid-39b62a86:885bf50d:33f360cf:a409bd11 -> ../../md126
lrwxrwxrwx 1 root root  11 May 27 08:10
md-uuid-42514e8a:2d127c98:7c2f52fe:60835b32 -> ../../md127
lrwxrwxrwx 1 root root  11 May 27 08:10
md-uuid-69270eac:a840f6e7:0199064b:d5863c5d -> ../../md125
lrwxrwxrwx 1 root root   9 May 27 08:10 wwn-0x5000c50072af4400 ->
../../sdb
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c50072af4400-part1
-> ../../sdb1
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c50072af4400-part2
-> ../../sdb2
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c50072af4400-part3
-> ../../sdb3
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c50072af4400-part4
-> ../../sdb4
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c50072af4400-part5
-> ../../sdb5
lrwxrwxrwx 1 root root   9 May 27 08:10 wwn-0x5000c500737a98a4 ->
../../sda
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c500737a98a4-part1
-> ../../sda1
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c500737a98a4-part2
-> ../../sda2
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c500737a98a4-part3
-> ../../sda3
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c500737a98a4-part4
-> ../../sda4
lrwxrwxrwx 1 root root  10 May 27 08:10 wwn-0x5000c500737a98a4-part5
-> ../../sda5


Cheers,
Wol
