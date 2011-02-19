From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sat, 19 Feb 2011 17:25:33 +0000
Message-ID: <4D5FFD0D.4030202@anonymous.org.uk>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com> <4D5FE3D6.8070006@anonymous.org.uk> <4D5FF386.6070003@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5FF386.6070003@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/02/2011 16:44, Phil Turmel wrote:
> On 02/19/2011 10:37 AM, John Robinson wrote:
>> On 19/02/2011 11:52, Mathias Bur=C3=A9n wrote:
>> [...]
>>> What I wonder is, how do I know what device is ata3? I do have 4
>>> devices of that model (WD20EARS). I've tried searching in /sys but
>>> there's nothing of value there (or I've missed it). If dmesg only
>>> showed the S/N...
>>> I posted the smartctl --all output of all devices here in case some=
one
>>> has time to take a look:
>>> http://stuff.dyndns.org/logs/smart-sd[a,b,c,d,e,f,g].log
>>
>> Try using Phil Turmel's excellent lsdrv script; I've attached the ve=
rsion I use on EL5, but I hacked it about to work on such an old distro=
 so I wouldn't swear it will work on more recent distros; Phil's origin=
al that does work on more recent distros can be found in the list archi=
ves around 6 November last year in the thread "Determining which spindl=
e is out of order".
>
> I've attached the latest version.  It falls back to smartctl if it ca=
n't find the sginfo utility.  It should work on both old and new sysfs =
layouts.

It still lists nothing on EL5. My SCSI hosts appear in /sys/devices/ as=
=20
follows:

/sys/devices/pci0000:00/0000:00:1f.2/host7/scsi_host:host7
/sys/devices/pci0000:00/0000:00:1f.2/host6/scsi_host:host6
/sys/devices/pci0000:00/0000:00:1f.2/host5/scsi_host:host5
/sys/devices/pci0000:00/0000:00:1f.2/host4/scsi_host:host4
/sys/devices/pci0000:00/0000:00:1f.2/host3/scsi_host:host3
/sys/devices/pci0000:00/0000:00:1f.2/host2/scsi_host:host2
/sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.1/host9/scsi_host:host9
/sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.0/host8/scsi_host:host8
/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host1/scsi_host:host1
/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host0/scsi_host:host0

So I changed the find regex as follows:

find /sys/devices/ -regex '.+/scsi_host\(:block\|:host[0-9]+\)?'

though I'd be interested to know why the simpler:

find /sys/devices/ -name 'scsi_host*'

isn't sufficient?

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
