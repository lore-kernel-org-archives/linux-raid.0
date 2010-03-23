From: Neil Brown <neilb@suse.de>
Subject: Re: BUG:write data to degrade raid5
Date: Tue, 23 Mar 2010 14:16:46 +1100
Message-ID: <20100323141646.2cfa68a3@notabene.brown>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jin zhencheng <zhenchengjin@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 19 Mar 2010 18:29:28 +0800
jin zhencheng <zhenchengjin@gmail.com> wrote:

> hi;
> 
> i use kernel is 2.6.26.2
> 
> what i do as follow:
> 
> 1, I create a raid5:
> mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
> --metadata=1.0 --assume-clean
> 
> 2, dd if=/dev/zero of=/dev/md5 bs=1M &
> 
> write data to this raid5
> 
> 3, mdadm --manage /dev/md5 -f /dev/sda
> 
> 4 mdadm --manage  /dev/md5 -f /dev/sdb
> 
> if i faild 2 disks ,then the OS kernel display OOP error and kernel down
> 
> 
> do somebody know why ?
> 
> Is MD/RAID5 bug ?

Certainly this is a bug.
2.6.26 is quite old now - it is possible that the bug has already been fixed.
If you are able to post the oops message - possibly use a digital camera to
get a photograph - then I can probably explain what is happening and whether
it has been fixed.

Thanks,
NeilBrown
