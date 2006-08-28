From: Neil Brown <neilb@suse.de>
Subject: RE: md: only binds to one mirror after reboot
Date: Mon, 28 Aug 2006 15:21:44 +1000
Message-ID: <17650.32104.71098.353892@cse.unsw.edu.au>
References: <C05CC316E92A964C9BDD81EE36AE05343C7071@x2k3.a-team.ihs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas Pelzner on Monday August 28
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Pelzner <Andreas.Pelzner@aixvision.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 28, Andreas.Pelzner@aixvision.net wrote:
> Pls. find the kernel messages here.

Thanks.

'md' and the drivers for you disks are not compiled into the kernel
but are present as modules in an 'initrd'.
So the kernel parameter or
  md=0,/dev/hda1,/dev/hdb1
is ignored and the code in the inird is completely responsible for
assembling md0.
You have a look at what it does:
  
  mkdir /foo
  mount -t cramfs /initrd.img  /foo
                  ^^^^^^^^^^^

You have to find the initrd that is being used and use that name here.
Then have a look at etc mdadm.conf in /foo.

Once you understand the problem you will need to remake your initrd to
get this right.

NeilBrown
