From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: Raid Persistent Superblock Question..
Date: Sun, 19 Jan 2003 13:04:36 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1030119130208.20317A-100000@Maggie.Linux-Consulting.com>
References: <006301c2bffc$77e2c7d0$c7e60c0a@mihaisandu2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <006301c2bffc$77e2c7d0$c7e60c0a@mihaisandu2>
To: Sandu Mihai <mihai.sandu@kpnqwest.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya

when you add a new scsi disk...  you have to be careful
about its unit number

make sure your dirves are properly configured...
	- sda is in fact the lowest scsi-ID
	- sdb is in fact lowest scsi-ID +1
	- add your new disks w/ higher scsi-IDs

all should work fine 

sda, sdb, sdc is (re-)assigned in the sequence of scsi-IDs

c ya
alvin

On Sun, 19 Jan 2003, Sandu Mihai wrote:

> 
> Is there any tool that can help someone edit the persistent superblock of a
> partition/device that is a member of an RAID array?
> 
> Problem:
>     I have md0 - raid1 - /dev/sda1 + /dev/sdb1 + persistent-superblock 1
> md0 happens to be my / partition.
>     If I will insert another two disks in that box (/dev/sdd, /dev/sdc  with
> /dev/sdc1, /dev/sdd1 being members of md0 RAID1 array, the disks are from
> another box..) the kernel will mess-up the things, by 'autodetecting' the
> newly added disks as md0, and not _my_ disks.
>     If I could alter the superblock info on the newly added disks, well,
> that will be good.
> So far, no HOWTO, and no docs mention the existence of a tool like this (you
> can only query the superblock, and that is all..)
> 


