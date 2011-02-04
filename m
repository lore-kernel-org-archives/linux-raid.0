From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: ADD_NEW_DISK failed: Invalid argument
Date: Fri, 4 Feb 2011 13:10:28 +1100
Message-ID: <20110204131028.5cae3c88@notabene.brown>
References: <iifhb6$inv$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iifhb6$inv$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Forrest <jlforrest@berkeley.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 03 Feb 2011 16:31:19 -0800 Jon Forrest <jlforrest@berkeley.edu> wrote:

> (I see that other people have had this problem
> but not in the same situation as me. Mine
> is probably as simple as you can get).
> 
> I'm learning about how to manage software raid
> by using loopback devices on a RHEL6 system
> (2.6.32-71.14.1.el6.i686).
> 
> I create two loopback devices thusly:
> 
> # dd if=/dev/zero of=file0 bs=1k count=100
> 100+0 records in
> 100+0 records out
> 102400 bytes (102 kB) copied, 0.000689998 s, 148 MB/s
> # cp file0 file1
> # losetup /dev/loop0 file0
> # losetup /dev/loop1 file1
> 
> I can create a RAID1 volume with no problems:
> 
> # mdadm --create /dev/md0 --raid-device=2 --level=1 /dev/loop0 /dev/loop1
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> 
> However, doing the same thing but creating a RAID0 volume
> fails thusly:
> 
> # dd if=/dev/zero of=file2 bs=1k count=100
> 100+0 records in
> 100+0 records out
> 102400 bytes (102 kB) copied, 0.000699377 s, 146 MB/s
> # cp file2 file3
> # losetup /dev/loop2 file2
> # losetup /dev/loop3 file3
> # mdadm --create /dev/md1 --raid-device=2 --level=0 /dev/loop2 /dev/loop3
> mdadm: Defaulting to version 1.2 metadata
> mdadm: ADD_NEW_DISK for /dev/loop2 failed: Invalid argument
> 
> I don't understand what went wrong? Any ideas?

Probably chunk size is larger than your 100k devices.

Try:

  mdadm --create /dev/md1 --raid-devices=2 --level=0 --metadata=1.0
  --chunksize=4 ....

The metadata=1.0 causes the least amount of space to be used for metadata.

OR just make much larger files.  Surely you can spare a few meg??

NeilBrown


> 
> Cordially,

