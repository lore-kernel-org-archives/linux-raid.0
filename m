From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: Reproducable OOPS with MD RAID-5 on 2.6.0-test11
Date: Tue, 02 Dec 2003 06:15:24 -0700
Sender: linux-lvm-admin@sistina.com
Message-ID: <3FCC906C.5040907@backtobasicsmgmt.com>
References: <3FCB4AFB.3090700@backtobasicsmgmt.com> <20031201141144.GD12211@suse.de> <3FCB4CFA.4020302@backtobasicsmgmt.com> <20031201155143.GF12211@suse.de> <3FCC0EE0.9010207@backtobasicsmgmt.com> <20031202082713.GN12211@suse.de> <20031202211002.C2009778@wobbly.melbourne.sgi.com>
Reply-To: linux-lvm@sistina.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-admin@sistina.com>
In-Reply-To: <20031202211002.C2009778@wobbly.melbourne.sgi.com>
Errors-To: linux-lvm-admin@sistina.com
List-Help: <mailto:linux-lvm-request@sistina.com?subject=help>
List-Post: <mailto:linux-lvm@sistina.com>
List-Subscribe: <http://lists.sistina.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@sistina.com?subject=subscribe>
List-Unsubscribe: <http://lists.sistina.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@sistina.com?subject=unsubscribe>
List-Archive: <http://lists.sistina.com/pipermail/linux-lvm/>
To: Nathan Scott <nathans@sgi.com>
Cc: Jens Axboe <axboe@suse.de>, LKML <linux-kernel@vger.kernel.org>, Linux-raid maillist <linux-raid@vger.kernel.org>, linux-lvm@sistina.com
List-Id: linux-raid.ids

Nathan Scott wrote:

> One thing that might be of interest - XFS does tend to pass
> variable size requests down to the block layer, and this has
> tripped up md and other drivers in 2.4 in the distant past.
> 
> Log IO is typically 512 byte aligned (as opposed to block or
> page size aligned), as are IOs into several of XFS' metadata
> structures.

Hey, thanks for the pointer! I think we're getting somewhere now. Here's 
a recap of the tested combinations:

XFS on raw disk: OK
XFS on LVM2 on single disk: OK
XFS on LVM2 on RAID-5: fails
ext2 on LVM2 on RAID-5: OK

I just tested XFS on LVM2 on RAID-5 using "-l sunit=8" while creating 
the filesystem to force log writes be block-sized and block-aligned; 
this seems to work :-) I have not been able to force a failure using my 
test script, although ATM the system is still running a RAID-5 resync of 
the array, but that should only make the problem more likely, not less.

So, this does appear to be an md/dm stacking problem, that is exposed by 
XFS sending non-block-sized and/or non-block-aligned IOs.


_______________________________________________
linux-lvm mailing list
linux-lvm@sistina.com
http://lists.sistina.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
