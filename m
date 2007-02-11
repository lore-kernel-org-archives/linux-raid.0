From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: old raid0run
Date: Sun, 11 Feb 2007 09:59:29 +0300
Message-ID: <45CEBED1.6000702@tls.msk.ru>
References: <pan.2007.02.11.06.33.05.974944@metm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <pan.2007.02.11.06.33.05.974944@metm.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marco Scoffier <marco@metm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Marco Scoffier wrote:
> Hello all,
> 
> I have an old raid0 with no superblocks.
> 
> I have just upgraded the machine with this raid and mdadm is incapable of
> mounting it.  Unfortunately raidtools will no longer compile*.  So I am a
> bit stuck as I would like to save the data on this raid0.
> 
> Can I create a new raid0 using mdadm ?
> 
>   mdadm -C -n 2 -c 128 -l 0 /dev/md0 /dev/hde1 /dev/hdg1

Well, mdadm is able to assemble it.  It's called 'build' (--build) --

  mdadm --build -n 2 -c 128 -l 0 /dev/md0 /dev/hde1 /dev/hdg1

> or should I build a new raid0 and then upgrade that to a raid0 with
> superblocks (how would I do that?)

I think the best option is to convert it to raid0-with-superblocks.
For that, I'd go this route:

  - build the array as above
  - fsck the filesystem on it
  - resize the filesystem to be, say, 1Mb smaller
  - stop the array
  - create new array as you've shown above with -C
  - and finally resize the filesystem to utilize all available space

Or something like that, anyway.

Sure, backing up data and restoring it after creating the array is
safer.

> Thanks for any pointers,
> 
> As there are no super-blocks mdadm is
> giving very little information:
> 
> mdadm -E /dev/hde1
> mdadm: No md superblock detected on /dev/hde1.

Well, it's expectable.  -E = show superblock contents.

> mdadm -As /dev/md0 
> mdadm: /dev/hde1 has no superblock - assembly aborted

Assembly needs devices with superblocks.  Try -B.

/mjt
