From: Nathan Hunsperger <linux-raid@hunsperger.com>
Subject: Re: A puzzling thing about RAID5: syslogd write the log success but another process can not read the /var/log/messages
Date: Wed, 7 Apr 2004 08:22:58 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040407152257.GJ17670@munchnet.com>
References: <407400F1.8090809@sinosoft.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <407400F1.8090809@sinosoft.com.cn>
To: Gewj <geweijin@sinosoft.com.cn>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gewj -

I believe you have your RAID numbers crossed.  RAID 5 requires a minimum
of 3 disks.  Perhaps you meant raid 1, which is a mirror.

I don't believe RAID would have caused the symptoms you saw (When RAID
detects a problem, assuming it has enough redundancy information, your
view of the data should not change.  Of course, if you lose 1 too many
disks, your data will not be intact, but you will be getting FS errors
like crazy.)

However, I have seen this type of symptom before on  some FreeBSD boxes
I co-maintain.  In those cases, a less experienced member of root would
notice a log file grow too big, delete it, and create a new 0-byte file.
However, syslog would still have the old file open, and be writing into
it.  But for anybody else, they would see a 0-byte file.  The problem
is that when you delete a file, it isn't actually deleted, it is just
unlinked from the directory structure.  When the last process to have the
file open closes it, it will then be gone.  Of course, this means that
your filesystem may fill up (check with df), although utilities like du
and ls will not show the file.  Yes, that is really fun to track down
at 3am when /var fills up.

Hope that answers your questions,
Nathan

On Wed, Apr 07, 2004 at 09:24:01PM +0800, Gewj wrote:
> hammm,tonight is funny because I got a puzzling thing just as....
> 
> my setup is a two-scsi-disk raid5 configuration...
> (Linux version 2.4.18-18.7.xsmp (Red Hat Linux 7.3 2.96-112)) #1 SMP Wed
> Nov 13 19:01:42 EST 2002)
> it work well for a long time, but now I found some day early one of the
> scsi disks failed, and I found out
> that that time syslogd restarted(why??) and it could write log infor to
> log file successfully.
> but at the same time , another process(named such as B,run by root) can
> not read
> the /var/log/messages,or what's more exactly, the messages file was look
> like empty to B then.
> (of course, the syslogd write log infor to /var/log/messages )
> 
> I wonder that if syslogd write the log infor to the well-work scsi disk
> , but the process B
> read the /var/log/messages from the crashed scsi disk,which cause it
> just like a empty file.
> 
> yes, it is quite unbelievable. but can some one show me a clue to this
> puzzling problem?
> What is the proper course of this action?
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
