From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Failed reads from RAID-0 array (from newbie who has read the FAQ)
Date: Fri, 16 Mar 2007 20:20:31 -0600 (CST)
Message-ID: <1536.72.21.237.163.1174098031.squirrel@www.multitool.net>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not a Linux newbie (I've even written a couple of books and done some
very light device driver work), but I'm completely new to the software
raid subsystem.

I'm doing something rather oddball. I'm making an array of USB flash
drives and comparing read and write rates.

Well, I've had great success writing. I've got seven flash drives on a
hub. I've joined them up both linear and raid0 and written large amounts
of data to them. But come time to read from them, linear works, but raid0
hangs after transferring just shy of 2G of data. It doesn't matter if it
reading from one file or from many files whose cumulative size is just shy
of 2G. It doesn't matter if I'm using "dd" or "cp" to read the file or
files.

The process doing the transfer is unkillable. Not with a kill -15 or a
kill -9. It won't die, but it also won't make progress.

"Linear" always works. Raid-0 always hangs.

Here are my mdadm commands to create the array:

mdadm --create /dev/md0 --level=linear --auto=md --chunk=32
--raid-devices=7 /dev/sd?

(The wildcard works because the seven flash drives are the only scsi
devices on the system).

The command for the raid-0 array is the same as above except for the
"--level=0" it takes to make a raid 0 array.

I then use "mkfs" to make the filesystem and mount the resulting array at
"/mnt"

Can anyone give a raid newbiw some tips? Is there something obvious I'm
missing? Would it help to provide strace/ltrace/ptrace of the hanging copy
command?

Any help (including URLs of manuals I should RTFM) would be most welcome.

Thanks!


-- 
Michael Schwarz


