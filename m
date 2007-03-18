From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: [Linux-usb-users] Failed reads from RAID-0 array (from newbie  
                   who has read the FAQ)
Date: Sun, 18 Mar 2007 11:44:34 -0600 (CST)
Message-ID: <3679.72.21.237.163.1174239874.squirrel@www.multitool.net>
References: <2885.72.21.237.163.1174167308.squirrel@www.multitool.net>      
    <Pine.LNX.4.44L0.0703172208400.16306-100000@netrider.rowland.org>   
    <3123.72.21.237.163.1174192963.squirrel@www.multitool.net>
    <3612.72.21.237.163.1174236988.squirrel@www.multitool.net>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3612.72.21.237.163.1174236988.squirrel@www.multitool.net>
Sender: linux-raid-owner@vger.kernel.org
To: mschwarz@multitool.net
Cc: Alan Stern <stern@rowland.harvard.edu>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

As I suspected, majordomo doesn't like attachments.

I looked through the logs. The only odd thing I see before the read that
hangs is this message:

smartd[3069]: Device: /dev/hda, 1 Currently unreadable (pending) sectors

Which I only see in /var/log/messages because the stack dump blows
whatever buffer size if reserved for dmesg (the whole stack trace doesn't
make it in).

I'm going to try a different computer running a different OS next.

Alan, Neil, I wasn't able to make anything of those logs. I've also
grabbed /var/log/message to get the gap between dmesg-4-* and dmesg-5-*.
I'll send that to you two in a separate message.

If anyone else would like my logs, let me know.


-- 
Michael Schwarz

> Okay. I've verified my hardware (by doing large write/reads to non-raid
> file systems on each of the seven USB flash drives on the hub).
>
> So this morning I booted cold and began gathering log data. I'm sending it
> to you guys (you hsould know this) before looking at it myself.  Here's
> the sequence:
>
> Cold boot
> Gnome login
> echo t > /proc/sysrq-trigger
> dmesg > dmesg-0-beforehub.log
> Attached hub with 7 drives
> dmesg > dmesg-1-afterhub.log
> mdadm --create /dev/md0 --auto=md --level=0 --raid-devices=7 /dev/sd?
> dmesg > dmesg-2-aftermdcreate.log
> mke2fs -b 4096 -R stride=16 /dev/md0
> dmesg > dmesg-3-aftermkfs.log
> mount /dev/md0 /mnt
> cp -rv ~mschwarz/FUTURAMA_S2D2/* /mnt
> dmesg > dmesg-4-afterbigwrite.log
> cp -rv /mnt/* fs2d2/
>
> At this point, the process hangs. So I ran:
>
> echo t > /proc/sysrq-trigger
> dmesg > dmesg-5-hungread.log
>
> ...in a different root window. All these operations were performed as root
> (in order to be as dangerous as possible -- actually, in order to reduce
> possible permissions issues; although I don't think there are any)
>
> All of these dmesg logs are attached in gzip format. I don't know what
> majordomo will do with those, but the cc's going directly to Alan and Neil
> should come through. I'm going to start combing these files myself, so if
> you guys want to save time, you can certainly give me a couple hours to
> get started! ;-)
>
> As always, I'm very grateful for your assistance and that of the group!
>
> --
> Michael Schwarz
>
>> Yeah, I understand that.
>>
>> Sorry, I use squirrelmail. Pretty limited...
>>
>> I'll get you a "raw" dmseg output when I replicate the problem.
>>
>

