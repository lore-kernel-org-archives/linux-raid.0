From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Failed reads from RAID-0 array (from newbie
 who has read the FAQ)
Date: Sat, 17 Mar 2007 16:49:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0703171642270.29501-100000@netrider.rowland.org>
References: <2677.72.21.237.163.1174154498.squirrel@www.multitool.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: <2677.72.21.237.163.1174154498.squirrel@www.multitool.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: Michael Schwarz <mschwarz@multitool.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

On Sat, 17 Mar 2007, Michael Schwarz wrote:

> Neil:
> 
> Relevant stack trace follows. Any suggestions? blk_backing_dev_unplug...
> Does that mean the raid subsystem thinks one of the usb drives has been
> removed? I assure you that physically this is untrue, but that doesn't
> mean that some sort logical disconnect hasn't happened...
> 
> Makes me wonder if one of my USB hub connections is intermittent...
> 
> I would also welcome any tips on any other developers group to follow up
> with. I haven't hacked any kernel code since the 2.2.x kernel and things
> have changed a bit! I don't mind digging into this, but I suspect I could
> get things cleared up fast if I could find the right subject expert!
> 
> 
> 
>  =======================
> cp            D E2FBEDB0  1784  4271   4270                     (NOTLB)
>        e2fbedb4 00200086 c15dc550 e2fbedb0 00000001 00200082 00001000
> 00000000
>        00000000 c15dc550 0000000a e94182b0 f3161430 26320f40 000001c5
> 00000000
>        e94183bc c1c8c480 00000000 ecd7d300 c04e0bf2 c042e0e4 f7d767f8
> 003b6622
> Call Trace:
>  [<c04e0bf2>] blk_backing_dev_unplug+0x73/0x7b
>  [<c042e0e4>] getnstimeofday+0x30/0xb6
>  [<c061ec7e>] io_schedule+0x3a/0x5c
>  [<c045626b>] sync_page+0x0/0x3b
>  [<c04562a3>] sync_page+0x38/0x3b
>  [<c061ed8a>] __wait_on_bit_lock+0x2a/0x52
>  [<c045625d>] __lock_page+0x58/0x5e
>  [<c043788e>] wake_bit_function+0x0/0x3c
>  [<c04569e3>] do_generic_mapping_read+0x1e0/0x459
>  [<c0458b0d>] generic_file_aio_read+0x173/0x1a6
>  [<c0456070>] file_read_actor+0x0/0xe0
>  [<c047202f>] do_sync_read+0xc7/0x10a
>  [<c0437859>] autoremove_wake_function+0x0/0x35
>  [<c0471f68>] do_sync_read+0x0/0x10a
>  [<c04728b6>] vfs_read+0xa6/0x152
>  [<c0472d0f>] sys_read+0x41/0x67
>  [<c0403f64>] syscall_call+0x7/0xb
>  =======================

This isn't much help.  The important processes here are khubd,
usb-storage, and scsi_eh_*.  Possibly some raid-related processes too, but 
I don't know which they would be.

It also would help a lot to see your dmesg log.  Especially if you would
build your kernel with CONFIG_USB_DEBUG turned on.

> Update:
>
> (For those who've been waiting breathlessly). It hangs at a particular
> point in a particular file. In other words, it doesn't depend on the total
> number of bytes transfered. Rather, when it reaches a particular point in
> a particular file (12267520 bytes into a file that is 1073709056 bytes
> long) it hangs.
>
> I begin to suspect that I have a "dead spot" in my USB hub. But what gets
> me if that is true is why does the write work? Do cp and dd not check to
> see if writes succeed?

Depends what you mean.  They do check the return codes from the underlying 
device drivers, but they don't try to read the data back to make sure it 
really was written.

> I know it isn't a particular flash drive because I've used two different
> sets of 7 USB drives and it seems to fail consistently no matter which.

But you haven't tried using different hubs, different USB cables, or
different computers.

> Nonetheless, I'm beginning to think I'm dealing with a hardware issue, not
> a kernel issue, just because it is so consistent.

People have reported problems in which the hardware fails when it 
encounters a certain pattern of bytes in the data stream.  Maybe you're 
seeing the same sort of thing.

Alan Stern


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
