From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 09:13:33 +0000
Message-ID: <4D5E383D.9010608@gmail.com>
References: <4D540F6C.6050904@gmail.com>	<20110215155315.55d35b8e@notabene.brown>	<4D5A92F3.1090004@turmel.org>	<4D5ACE4B.9040309@gmail.com>	<4D5AD613.3040402@turmel.org>	<20110216004524.67abe977@natsu>	<AANLkTikLWmC1u3rMFktwULgSPh-zL+D-xgcyogcJfqnP@mail.gmail.com> <20110217204221.7a865364@natsu>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217204221.7a865364@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Roman,
Sorry to be so persistent on something that is not Linux raid specific, 
but I still can't get blkid to run, the message is:

proxmox:~# ls -la /usr/lib/debug/sbin/blkid
-rwx------ 1 root root 19887 2008-10-13 04:54 /usr/lib/debug/sbin/blkid

proxmox:~# /usr/lib/debug/sbin/blkid --help
-bash: /usr/lib/debug/sbin/blkid: cannot execute binary file

If I can't run it directly I'm pretty sure symlinking it will not make 
any difference.  It's weird, normally when I apt-get things it modifies 
the path etc and does everything required to make it work, I would have 
thought if I installed a debug version of something it should add the 
debug path as well ?

blkid always works on my Ubuntu boxes, I don't know why this is any 
different (apart from being a different distribution, it's still a 
mature program, package and platform).

:-)

Simon

On 17/02/2011 15:42, Roman Mamedov wrote:
> On Thu, 17 Feb 2011 15:10:32 +0000
> Simon Mcnair<simonmcnair@gmail.com>  wrote:
>
>> proxmox:~# dpkg -S blkid
>> libblkid1: /lib/libblkid.so.1.0
>> libblkid1: /lib/libblkid.so.1
>> libblkid1: /usr/share/doc/libblkid1/changelog.Debian.gz
>> libblkid1: /usr/share/doc/libblkid1/copyright
>> libblkid1: /usr/share/doc/libblkid1
>> e2fsprogs-dbg: /usr/lib/debug/sbin/blkid
>>
>> proxmox:~# apt-get install e2fsprogs-dbg
>> Reading package lists... Done
>> Building dependency tree
>> Reading state information... Done
>> e2fsprogs-dbg is already the newest version.
>> 0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
>>
>>
>> I still can't blkid installed, even though I have e2fsprogs-dbg installed...
> /usr/lib/debug/sbin/ is not in system 'path', so you won't be able to run the
> program just by entering 'blkid' into the shell prompt.
> Either use the complete file name and path, e.g.
>
>    # /usr/lib/debug/sbin/blkid --help
>
> or symlink /usr/lib/debug/sbin/blkid to something like /usr/local/sbin/blkid.
>
