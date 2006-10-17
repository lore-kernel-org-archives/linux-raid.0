From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: libata hotplug and md raid?
Date: Tue, 17 Oct 2006 10:07:07 +0200
Message-ID: <20061017080707.GE11884@boogie.lpds.sztaki.hu>
References: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com> <4507E2A9.7070306@emc.com> <4507E641.7090508@gmail.com> <c384c5ea0609140524ofed0dd8v6f1b89a6b4d67f75@mail.gmail.com> <45342287.407@pobox.com> <17716.14507.187306.941214@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17716.14507.187306.941214@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mark Lord <mlord@pobox.com>, linux-raid@vger.kernel.org, Leon Woestenberg <leon.woestenberg@gmail.com>, Tejun Heo <htejun@gmail.com>, Ric Wheeler <ric@emc.com>, Greg KH <gregkh@suse.de>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 17, 2006 at 11:58:03AM +1000, Neil Brown wrote:

> udev can find out what needs to be done by looking at
> /sys/block/whatever/holders. 

Are you sure?

$ cat /proc/mdstat
[...]
md0 : active raid1 sdd1[1] sdc1[0] sdb1[2] sda1[3]
      393472 blocks [4/4] [UUUU]
[...]
$ ls -l /sys/block/sda/holders
total 0

Vanilla 2.6.18 kernel. In fact, all the /sys/block/*/holders directories
are empty here.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
