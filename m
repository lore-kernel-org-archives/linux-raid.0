From: jlcenter@comcast.net
Subject: Re: Install grub2 to /dev/md126 fails
Date: Fri, 6 Jan 2012 03:43:32 +0000 (UTC)
Message-ID: <1737559486.454681.1325821412593.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
References: <20120103103401.2d90498e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120103103401.2d90498e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm going to try again to build the raid1 array, but I was wondering if the GPT partitions should be created first on the physical disks, then create & assemble the array?  Or, if the array should be created & assembled, then partition the array?  I'm raiding the whole disk(s), not partitions.  My feeling is that the array should be built first, then partitioned, but I have been known to be wrong... :-)  Also, is there any special order to the partitions, i.e., does the bios boot partition have to be the first partition on the array?

Thanks.

    -John

