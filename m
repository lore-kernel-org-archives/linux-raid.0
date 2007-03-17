From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: Failed reads from RAID-0 array;
	still no joy in Mudville.
Date: Sat, 17 Mar 2007 13:21:13 -0600 (CST)
Message-ID: <2760.72.21.237.163.1174159273.squirrel@www.multitool.net>
References: <1536.72.21.237.163.1174098031.squirrel@www.multitool.net>   
	<17915.32057.221461.617241@notabene.brown> <45FC33A4.2090408@tmr.com>
	<2745.72.21.237.163.1174158791.squirrel@www.multitool.net>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: <2745.72.21.237.163.1174158791.squirrel@www.multitool.net>
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

Update:

(For those who've been waiting breathlessly). It hangs at a particular
point in a particular file. In other words, it doesn't depend on the total
number of bytes transfered. Rather, when it reaches a particular point in
a particular file (12267520 bytes into a file that is 1073709056 bytes
long) it hangs.

I begin to suspect that I have a "dead spot" in my USB hub. But what gets
me if that is true is why does the write work? Do cp and dd not check to
see if writes succeed?

I know it isn't a particular flash drive because I've used two different
sets of 7 USB drives and it seems to fail consistently no matter which.

Nonetheless, I'm beginning to think I'm dealing with a hardware issue, not
a kernel issue, just because it is so consistent.

Thanks again for all the help.


-- 
Michael Schwarz

> I'll try playing around with IO sizes with dd.
>
> What I'm finding so far is ABSOLUTE consistency on where it locks. If it
> were a race condition with kernel locks I guess I would expect it to be
> more indeterminate (in my limited experience) unless it is due to specific
> "deadly embrace" condition between the usb drivers(s) and the raid
> subsystem.
>
> I must admit that I'm not familiar enough with either one. I will also
> mention that I experienced this lockup phenomenon with both a stock Fedora
> Core 6 i686 kernel and with a stock Ubuntu kernel, so the behavior isn't
> terribly kernel compile/module mix sensetive.
>
> I've downloaded the kernel-devel package for my Fedora kernel and I'm
> going to start working backwards from the stack trace I've captured to see
> where I'm hanging and why. strace wasn't particularly helpful since the
> write to file was buffered and so I can't be sure I have the call that
> failed. (I'll take a look and see if there's an 'unbuffered write' switch
> on strace -- there probably is).
>
> Anyways, I'm still hoping someone who knows a lot will see this and say
> "oh, yeah! That's because of BLAH." I don't mind becoming more
> knowledgeable about the 2.6.x kernel, but this wasn't how I wanted to go
> about it! ;-)
>
> Thanks again, all...
>
> What I find odd is that it seems to be a "per-process" problem. I can
> still access the md drive from other processes when the copy is hung.  I'm
> going to see if it is "positional" by copying the file that is "hung"
> alone and see if it hangs in the same place on the same file, or if it
> hangs later or what,,, There will be more posts from me. (Fair warning to
> all!)
>
> --
> Michael Schwarz
>
>> Neil Brown wrote:
>>> On Friday March 16, mschwarz@multitool.net wrote:
>>>
>>>> I'm not a Linux newbie (I've even written a couple of books and done
>>>> some
>>>> very light device driver work), but I'm completely new to the software
>>>> raid subsystem.
>>>>
>>>> I'm doing something rather oddball. I'm making an array of USB flash
>>>> drives and comparing read and write rates.
>>>>
>>>> Well, I've had great success writing. I've got seven flash drives on a
>>>> hub. I've joined them up both linear and raid0 and written large
>>>> amounts
>>>> of data to them. But come time to read from them, linear works, but
>>>> raid0
>>>> hangs after transferring just shy of 2G of data. It doesn't matter if
>>>> it
>>>> reading from one file or from many files whose cumulative size is just
>>>> shy
>>>> of 2G. It doesn't matter if I'm using "dd" or "cp" to read the file or
>>>> files.
>>>>
>>>> The process doing the transfer is unkillable. Not with a kill -15 or a
>>>> kill -9. It won't die, but it also won't make progress.
>>>>
>>>> "Linear" always works. Raid-0 always hangs.
>>>>
>>>
>>> My guess would be a locking bug in the usb storage driver or some
>>> lower level USB driver..
>>> A significant difference between raid0 and linear is that a largish IO
>>> will touch all drives for raid-0, but only one or two for linear.
>>> That gives much more opportunity for locking bugs to hit.
>>>
>>> When it is in the hanging state, do
>>>   echo t > /proc/sysrq-trigger
>>>
>>> and look in the kernel logs for the stack trace of all processes.
>>> Hopefully the stack trace for the processes in 'D' state will be
>>> informative.
>>>
>>> NeilBrown
>>>
>>>
>>>
>>>> Here are my mdadm commands to create the array:
>>>>
>>>> mdadm --create /dev/md0 --level=linear --auto=md --chunk=32
>>>> --raid-devices=7 /dev/sd?
>>>>
>>>> (The wildcard works because the seven flash drives are the only scsi
>>>> devices on the system).
>>>>
>>>> The command for the raid-0 array is the same as above except for the
>>>> "--level=0" it takes to make a raid 0 array.
>>>>
>>>> I then use "mkfs" to make the filesystem and mount the resulting array
>>>> at
>>>> "/mnt"
>>>>
>>>> Can anyone give a raid newbiw some tips? Is there something obvious
>>>> I'm
>>>> missing? Would it help to provide strace/ltrace/ptrace of the hanging
>>>> copy
>>>> command?
>>>>
>>>> Any help (including URLs of manuals I should RTFM) would be most
>>>> welcome.
>>>>
>>>> Thanks!
>>>>
>>>>
>>>> --
>>>> Michael Schwarz
>>>>
>>
>> Neil, would retrying this with small i/o show anything, assuming your
>> thought is the cause? Also, would it give useful information to usee dd
>> with direct i/o on read:
>>   dd if=/dev/md0 iflag=direct bs=1024k of=/dev/null
>> and see if large buffer with O_DIRECT works?
>>
>> These are suggestions on getting more info, if the trace doesn't clarify
>> the problem.
>>
>> --
>> bill davidsen <davidsen@tmr.com>
>>   CTO TMR Associates, Inc
>>   Doing interesting things with small computers since 1979
>>
>>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
