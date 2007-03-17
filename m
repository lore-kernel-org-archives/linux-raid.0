From: Neil Brown <neilb@suse.de>
Subject: Re: Failed reads from RAID-0 array (from newbie
	who has read the FAQ)
Date: Sat, 17 Mar 2007 16:31:37 +1100
Message-ID: <17915.32057.221461.617241@notabene.brown>
References: <1536.72.21.237.163.1174098031.squirrel@www.multitool.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: message from Michael Schwarz on Friday March 16
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: mschwarz@multitool.net
Cc: linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

On Friday March 16, mschwarz@multitool.net wrote:
> I'm not a Linux newbie (I've even written a couple of books and done some
> very light device driver work), but I'm completely new to the software
> raid subsystem.
> 
> I'm doing something rather oddball. I'm making an array of USB flash
> drives and comparing read and write rates.
> 
> Well, I've had great success writing. I've got seven flash drives on a
> hub. I've joined them up both linear and raid0 and written large amounts
> of data to them. But come time to read from them, linear works, but raid0
> hangs after transferring just shy of 2G of data. It doesn't matter if it
> reading from one file or from many files whose cumulative size is just shy
> of 2G. It doesn't matter if I'm using "dd" or "cp" to read the file or
> files.
> 
> The process doing the transfer is unkillable. Not with a kill -15 or a
> kill -9. It won't die, but it also won't make progress.
> 
> "Linear" always works. Raid-0 always hangs.

My guess would be a locking bug in the usb storage driver or some
lower level USB driver..
A significant difference between raid0 and linear is that a largish IO
will touch all drives for raid-0, but only one or two for linear.
That gives much more opportunity for locking bugs to hit.

When it is in the hanging state, do
  echo t > /proc/sysrq-trigger

and look in the kernel logs for the stack trace of all processes.
Hopefully the stack trace for the processes in 'D' state will be
informative.

NeilBrown


> 
> Here are my mdadm commands to create the array:
> 
> mdadm --create /dev/md0 --level=linear --auto=md --chunk=32
> --raid-devices=7 /dev/sd?
> 
> (The wildcard works because the seven flash drives are the only scsi
> devices on the system).
> 
> The command for the raid-0 array is the same as above except for the
> "--level=0" it takes to make a raid 0 array.
> 
> I then use "mkfs" to make the filesystem and mount the resulting array at
> "/mnt"
> 
> Can anyone give a raid newbiw some tips? Is there something obvious I'm
> missing? Would it help to provide strace/ltrace/ptrace of the hanging copy
> command?
> 
> Any help (including URLs of manuals I should RTFM) would be most welcome.
> 
> Thanks!
> 
> 
> -- 
> Michael Schwarz
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
