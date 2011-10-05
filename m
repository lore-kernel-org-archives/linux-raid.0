From: Sebastian Muniz <sjmuniz@gmail.com>
Subject: Re: Creating an md with 3TB drives.
Date: Wed, 05 Oct 2011 19:25:23 -0300
Message-ID: <4E8CD953.8030902@gmail.com>
References: <4E82D53F.3050409@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E82D53F.3050409@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 9/28/2011 5:05 AM, Marcin M. Jessa wrote:

> # parted /dev/sde
> GNU Parted 2.3
> Using /dev/sde
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted) mklabel gpt
> Warning: The existing disk label on /dev/sde will be destroyed and all
> data on this disk will be lost. Do you want
> to continue?
> Yes/No? yes
> (parted) mkpart primary 0 -0
> Warning: The resulting partition is not properly aligned for best
> performance.
> Ignore/Cancel? ignore
> (parted) print
> Model: ATA Hitachi HDS72303 (scsi)
> Disk /dev/sde: 3001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>
> Number Start End Size File system Name Flags
> 1 17.4kB 3001GB 3001GB primary
>
> (parted) quit
>
I run into something similar working with 2Terabytes disks.
I had to use % instead o sizes.
Eg:
(parted) mkpart
Partition name?  []? 1
File system type?  [ext2]?
Start? 0
End? 100%
(parted) set 1
Flag to Invert? raid
New state?  [on]/off? on

I think the "primary" concept is for DOS 3.3 partition tables and might 
not apply here.
Please, correct if I am wrong.
THanks
Sebastian
