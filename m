From: Paul Downs <paul@positive-internet.com>
Subject: Re: Booting with raided root, debian system
Date: Thu, 10 Apr 2003 16:41:01 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030410154101.GB11470@u4ia>
References: <20030410123746.GA11470@u4ia> <3E9567AC.9060104@hum.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E9567AC.9060104@hum.auc.dk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Mads Peter Bach (mpb@hum.auc.dk) wrote :

Hi,

> A copy of the errormessages before "attempt to kill init" would be quite 
> helpful :-)

  I had to do another run on a different server so the results were slightly
different from my memory, the results where the same:

Ext3-fs: unable to read superblock
mount: wrong fs type /dev2/root xxxxxxxxxxxxxxxxxxxxx
cramfs: wrong magic
mount: wrong fs type /dev2/root xxxxxxxxxxxxxxxxxxxxx
warning: can't open mtab
pivot_root: no such file or directory
/sbin/init: 107: cannot open /dev/console no such file
kernel panic: attempt to kill init!

> Also, a copy of lilo's output when you install it might help.

dev3:~$ mount -text3 /dev/md0 /mnt
dev3:~$ lilo -r /mnt

  With boot and root set to /dev/md0.  Output line was as you expect (e.g.
installing to /dev/md0 etc. etc.  said it installed ok) however this was the
penultimate line:

Unexpected dirty buffer encountered at do_get_write_access:613 (09:00
blocknr 0)


Any help appreciated.

Paul
