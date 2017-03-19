From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Read data from disk that was part of RAID1 array
Date: Sun, 19 Mar 2017 10:18:32 +0000
Message-ID: <58CE5AF8.5070907@youngman.org.uk>
References: <008801d29ea3$3e858000$bb908000$@warren-selbert.com>
 <000c01d29f74$ae85c230$0b914690$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000c01d29f74$ae85c230$0b914690$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/03/17 23:17, Peter Sangas wrote:
> 
> 
>> From: Peter Sangas [mailto:pete@wnsdev.com]
>> I have only one disk from a RAID1 array and I would like to read data from
> one of the
>> partitions.  This there a way to mount this and read the data?
> 
> This worked for me:
> 
> mdadm --create /dev/md10 -l 1 -n 2 /dev/sda missing     md10 is chosen to
> avoid conflicts with existing RAID1
> 
> mount /dev/md10 /mnt 
> 
NEVER NEVER NEVER use --create !!!

YOU WERE LUCKY !!!

Use something like --assemble --force, which will set up a working array
if it can. If that had been an old array, with a different offset or
superblock or the like, you would have trashed the superblock and
created a new array, which thought that the data in the array was
somewhere other than where it really was.

At which point, it would have been "go to your backups" or a major
forensic recovery.

Cheers,
Wol

