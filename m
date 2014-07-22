From: Phil Turmel <philip@turmel.org>
Subject: Re: Booting after Debian upgrade: /dev/md5 does not exist
Date: Tue, 22 Jul 2014 08:29:31 -0400
Message-ID: <53CE592B.6030706@turmel.org>
References: <53CE1C39.3070000@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CE1C39.3070000@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Ron,

On 07/22/2014 04:09 AM, Ron Leach wrote:
> List, good morning,
> 
> After updating a 2 x 2TB RAID1 server from Debian Lenny to Debian
> Squeeze today (first stage of 2-stage process to upgrade to current
> Debian stable, Wheezy), boot sequence stops with a warning that /dev/md5
> does not exist. (7 partitions; /dev/md5 is mounted on /home; md0 to md4
> exist and mount ok, and so does md6; mdstat shows them synchronised.)

[trim /]

> Is there another data file somewhere I need to repair so that mdadm sees
> /dev/md5 and starts that array?

Yes, there's a copy of mdadm.conf in your initramfs that governs what is
assembled in the early boot phase.  Strictly speaking, only the arrays
needed to get to your root filesystem *must* be assembled then, but all
the distros I've tried assemble everything then.  The "mkinitrd" or
"update-initramfs" utility will copy your mdadm.conf into the initramfs.

> Here's mdadm.conf
> 
> D5s2:/# cat /etc/mdadm/mdadm.conf
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
> 
> # by default, scan all partitions (/proc/partitions) for MD superblocks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE partitions
> 
> # auto-create devices with Debian standard permissions
> CREATE owner=root group=disk mode=0660 auto=yes
> 
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
> 
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR root@systemdesk
> 
> # definitions of existing MD arrays
> ARRAY /dev/md0 level=raid1 num-devices=2
> UUID=eb3b45e8:e1d73b1a:63042e90:fced6612
> ARRAY /dev/md1 level=raid1 num-devices=2
> UUID=93a0b403:18aa4e20:f77b0142:25a55090
> ARRAY /dev/md2 level=raid1 num-devices=2
> UUID=99104b71:9dd6cf88:e1a05948:57032dd7
> ARRAY /dev/md3 level=raid1 num-devices=2
> UUID=5dbd5605:1d61cbaa:ac5c64ee:5356e8a9
> ARRAY /dev/md4 level=raid1 num-devices=2
> UUID=725cfde4:114fef9a:4ed1ccad:18d72d44
> ARRAY /dev/md5 level=raid1 num-devices=2
> UUID=5bad4c7c:780696f4:fbaacbb9:204d67b9
> ARRAY /dev/md6 level=raid1 num-devices=2
> UUID=94171c8e:c47d18a8:c073121c:f9f222fe

If you want your boot process to be as robust as possible, omit the
'level=' and 'num-devices=' selectors in the ARRAY clauses and identify
your filesystems in fstab with LABEL= or UUID= taken from the output of
"blkid".  (Not the array UUIDs.)

You can start by using "mdadm -Es >>/etc/mdadm/mdadm.conf", deleting the
unnecessary parts, and adjusting array numbers to suit your preferences.

Phil
