From: Alex <mysqlstudent@gmail.com>
Subject: Re: Possible data corruption after rebuild
Date: Fri, 6 Jul 2012 12:15:47 -0400
Message-ID: <CAB1R3sj-oaotH1m1ojJKP+xm9OGiiPdEW91nfrs30MLB0XeR5g@mail.gmail.com>
References: <CAB1R3sjHtWwE7=MOqTzS7omiE-ebxqBPNaMMh-+_AYw3WgLtxg@mail.gmail.com>
	<CAB1R3sgwiM25ftpfZ3GkQNkGudwnk=R6Mu3orJJ3zYAc3g1C1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sgwiM25ftpfZ3GkQNkGudwnk=R6Mu3orJJ3zYAc3g1C1w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm sorry for spamming, but I was in the process of canceling the
fsck, and it looks like it ran anyway:

#

*** ext3 journal has been deleted - filesystem is now ext2 only ***

^[[D^CTruncating orphaned inode 94375075 (uid=0, gid=504, mode=064, size=5339)

/dev/md2: ***** FILE SYSTEM WAS MODIFIED *****

When I tried to mount the filesystem now:

# mount -o ro -t ext2 /dev/md2 /tmp/dave
mount: wrong fs type, bad option, bad superblock on /dev/md2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

I really hope someone can help.

Thanks,
Alex
