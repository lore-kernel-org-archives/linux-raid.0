From: Arun Khan <knura9@gmail.com>
Subject: Re: Unable to reactivate a RAID10 mdadm device
Date: Mon, 25 Feb 2013 11:52:38 +0530
Message-ID: <CAHhM8gDP+-V7tsxqD1jr5n5YB8LoDQoOT3Z4c0nVr1Lps29k9g@mail.gmail.com>
References: <CAHhM8gC0zgmAY1hZ9uPCa3F7oYO2vh-84m4XoZmSa0NrtsDbsw@mail.gmail.com>
	<2951248.2.1361716023024.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2951248.2.1361716023024.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Feb 24, 2013 at 7:57 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:
>> I connected the new hard disk, partitioned /dev/sdb1 to match size and
>> partition id (fd),
>
> Out of interest - why do you use partitions if you use whole drives for the RAID?
>

The system has a total of 5 disk devices.

1. /dev/sda is a 4GB CF card with a minimal Debian Squeeze (amd64).

The other four are in the order (SATA ports 0,1,2,3)

2. 250GB is /dev/sdb
3. 160GB is /dev/sdc
4. 160GB is /dev/sdd
5. 160GB is /dev/sde

/dev/sdb1 (part id=fd) is slightly larger than /dev/sd[cde]1,
remainder of the disk /dev/sdb is used for /tmp, /var, /var/tmp/, /opt
etc.

Partitions v/s Entire disk --
The wiki link <https://raid.wiki.kernel.org/index.php/Partition_Types>
suggests both are OK

My understanding is that partid must be = fd for autodetect.   To play
it safe, I have created partitions with part_id=fd.

-- Arun Khan
