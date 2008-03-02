From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 02 Mar 2008 18:20:31 +0300
Message-ID: <47CAC5BF.6060600@msgid.tls.msk.ru>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:
> Hi all!

Hello.

> Hardware:
> Tyan Thunder K8W (S2885)
> Dual Opteron 254, 2GB (2x2x512MB) RAM, 2x Promise SATA II TX4, Adaptec 29160
> 4x WD RE2-GP 1TB on the Promise (for raid5)

[]
> [exact command unavailable, see below. RAID5, 4 disks, 1024K chunk
> size, internal bitmap, V1 superblock]

ok.

> Tried creating a filesystem:
> 
> mke2fs -E stride=256 -j -L tb-storage -m1 -T largfile4 /dev/md0
> 
> That was glacially slow, "writing inode tables" went up about 3-4/sec
> (22357 total). Since I had forgotten the crypto layer anyway I
> CTRL-Ced that attempt and added it:
> 
> [exact command unavailable, see below. Used 2048 (512byte sectors) for
> LUKS payload alignment, which should land on it chunk boundaries]
> 
> OK. Back to the fs again, same command, different device. Still
> glacially slow (and still running), only now the whole box is at a
> standstill, too. cat /proc/cpuinfo takes about 3 minutes (!) to
> complete, I'm still waiting for top to launch (15min and counting).
> I'll leave mke2fs running for now ...

What's the state of your array at this point - is it resyncing?

> So, is all this normal? What did I do wrong, what can I do better?

In order to debug, try the following:

  o how about making filesystem(s) on individual disks first, to see
    how that will work out?  Maybe on each of them in parallel? :)

  o try --assume-clean when creating the array - this will omit resync
    and the array will be "clean" from the beginning (which is not bad
    when you will run mkfs on it anyway).  And try creating the filesystem
    on a clean (non-resyncing) array.

  o don't use crypto layer yet, - it seems does not hurt, just additional
    complexity

  o look at your interrupts (/proc/interrupts, or just run vmstat with
    some interval while the system working hard) - I bet your promises
    are taking all system time in irq context....

/mjt
