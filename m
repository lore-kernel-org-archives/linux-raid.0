From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: accidently pulled to many devices, raid6 wont start.
Date: Thu, 5 Dec 2013 17:08:09 +0000
Message-ID: <BLU0-SMTP97A46BD35BEBFA45110CC398D70@phx.gbl>
References: <BLU0-SMTP16236357B62A13D8FFAC14198D70@phx.gbl>
	 <52A08162.3080706@fastmail.fm>
	 <BLU0-SMTP2081DE3677BA1FD887C35BC98D70@phx.gbl>
	 <52A08E50.30609@fastmail.fm>
	 <BLU0-SMTP3325A7BDB48F7600841601398D70@phx.gbl>
	 <52A0A306.9070401@fastmail.fm>
	 <BLU0-SMTP2166AD61B636049F4A8A8798D70@phx.gbl>
	 <52A0AE50.2040506@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A0AE50.2040506@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 
> Sorry, I don't understand what you mean. sdb6 starts at 1928 sectors? 
> Assuming you have either 4k or 512B hw-sector disks that shouldn't make 
> a difference for alignment. If at all, I would correct it only once I 
> would have full redundancy.

I think I've managed to get it back using the 4 disks I was happy
with...

> 
> > offset (I have git, and have built from source before if it comes to
> > that... but a binary would be more helpful, or perhaps a mdadm that had
> > the original 2048 offset?) then clear the superblock from b and c and
> > re-add them to re-build the redundancy.
> 
> 
> Well, I could probably build mdadm for you (if I should have the chroot 
> matching your distribution), but can't you just download an older or a 
> recent version for your distribution?

What I did was:-

wilsonjonathan@BorgCUBE:~$ git clone git://neil.brown.name/mdadm
Cloning into 'mdadm'...
remote: Counting objects: 12848, done.
remote: Compressing objects: 100% (4434/4434), done.
remote: Total 12848 (delta 9627), reused 11123 (delta 8405)
Receiving objects: 100% (12848/12848), 3.37 MiB | 184 KiB/s, done.
Resolving deltas: 100% (9627/9627), done.
wilsonjonathan@BorgCUBE:~$ cd mdadm
wilsonjonathan@BorgCUBE:~/mdadm$ make

<snip compliation stuff>

wilsonjonathan@BorgCUBE:~/mdadm$ ./mdadm --version
mdadm - v3.3-38-gb11fe74 - 03th December 2013

wilsonjonathan@BorgCUBE:~/mdadm$ sudo ./mdadm --create --assume-clean
--level=6 --raid-devices=6 --chunk=64
--data-offset=1M /dev/md5 /dev/sdd6 /dev/sde6 /dev/sdf6 /dev/sda6
missing missing
[sudo] password for wilsonjonathan: 
mdadm: /dev/sdd6 appears to be part of a raid array:
       level=raid6 devices=6 ctime=Thu Dec  5 15:33:34 2013
mdadm: /dev/sde6 appears to be part of a raid array:
       level=raid6 devices=6 ctime=Thu Dec  5 15:33:34 2013
mdadm: /dev/sdf6 appears to be part of a raid array:
       level=raid6 devices=6 ctime=Thu Dec  5 15:33:34 2013
mdadm: /dev/sda6 appears to be part of a raid array:
       level=raid6 devices=6 ctime=Thu Dec  5 15:33:34 2013
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md5 started.


Using disk manager in debian I can see md5, and the volume "md5mnt 3.8TB
ext4" as a single large partition.

I will run a fsck on it, then if thats ok will mount it read only and
have a poke around, then if thats ok will unmount it and add in the
missing drives/partitions.

Hopefully this means its all now ok *sigh of relief*

Thank you so much for your help so far on this, its been much
appreciated.

Jon.


> 
> 
> Cheers,
> Bernd
> 
> 


