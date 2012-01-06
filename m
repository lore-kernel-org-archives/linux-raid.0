From: jlcenter@comcast.net
Subject: Re: Install grub2 to /dev/md126 fails
Date: Fri, 6 Jan 2012 15:32:14 +0000 (UTC)
Message-ID: <123493149.466191.1325863934205.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
References: <2012259890.359354.1325640910810.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012259890.359354.1325640910810.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm going to try again to build the raid1 array, but I was wondering if the GPT partitions should be created first on the physical disks, then create & assemble the array?  Or, if the array should be created & assembled, then partition the array?  I'm raiding the whole disk(s), not partitions.  Reading the wiki, I get the impression the first way is preferable, but most of the descriptions I've read on-line suggest doing the latter.   Also, for mdadm with GPT partitions, is there any preferred order to the partitions, i.e., does the bios boot partition have to be the first partition on the array?

Thanks.

    -John
