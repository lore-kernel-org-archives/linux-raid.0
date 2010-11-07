From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Determining which spindle is out of order
Date: Sun, 07 Nov 2010 21:22:20 +0000
Message-ID: <4CD7188C.2000206@anonymous.org.uk>
References: <B9.A1.19545.A1017DC4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B9.A1.19545.A1017DC4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Phil Turmel' <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/2010 20:46, Leslie Rhorer wrote:
[...]
>> I did another version, with regular expressions to accommodate the
>> variations.  Please give it a shot.
>
> 	The regular expression doesn't work, here, but the rest of the
> script now works on the older server.  I replaced the find statement with
>
> find /sys/devices/  -name "scsi_host*" |check_host
>
> 	and it works.

I also changed the find command again and it also works, with one nit, 
which is probably just CentOS/RHEL being odd. See the following output:

# ~john/projects/lsdrv/lsdrv
Controller device @ pci0000:00/0000:00:1f.2 [ahci]
   SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI 
Controller
     host7: [Empty]
     host6: [Empty]
     host5: [Empty]
     host4: /dev/sdc ATA ST31000528AS {SN: 9VP4XCQP}
     host3: /dev/sdb ATA SAMSUNG HD103UJ {SN: S1PVJ1CQ602162 }
     host2: /dev/sda ATA Hitachi HDS72101 {SN: JP2921HQ0J0PZA}
Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.1 [aic7xxx]
   SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 01)
     host9: [Empty]
Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.0 [aic7xxx]
   SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 01)
     host8: [Empty]
Controller device @ pci0000:00/0000:00:1c.4/0000:03:00.0 [pata_marvell]
   IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II 
Controller (rev b2)
     host1: [Empty]
sginfo(open): No such file or directory
file=/dev/sr0, or no corresponding sg device found
Is sg driver loaded?
     host0: /dev/sr0 HL-DT-ST DVD-RAM GH22NP20

The various links in sysfs refer to sr0 but I don't have a /dev/sr0, I 
have /dev/scd0. I guess that's the udev rules Red Hat chose. Anyway, my 
fix was to add 2>/dev/null into the sginfo command, which makes the 
warning go away - sginfo -s /dev/scd0 gives me no serial anyway.

The only other improvement would be better formatting for controllers 
with multiple devices, e.g. IDE interfaces, port multipliers and real 
SCSI cards, which could have 2, 5 or 15 devices attached so displaying 
the SCSI device ID could be helpful in those cases. It doesn't apply to 
me but I thought of it when someone had both primary and slave devices 
on their IDE controller, and someone else mentioned port multipliers.

Cheers,

John.

