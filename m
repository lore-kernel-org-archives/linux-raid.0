From: Robin Bowes <robin-gmane@robinbowes.com>
Subject: Re: error opening /dev/md2: No such file or directory
Date: Thu, 02 Dec 2004 18:37:28 +0000
Message-ID: <41AF60E8.30703@robinbowes.com>
References: <conlcb$14p$1@sea.gmane.org> <41AF5F5A.4090709@starnetworks.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41AF5F5A.4090709@starnetworks.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kevin P. Fleming wrote:
> Robin Bowes wrote:
> 
>> # mdadm --create /dev/md2 --level=1 --raid-devices=2 /dev/sdc1 missing
>> mdadm: error opening /dev/md2: No such file or directory
> 
> In the meantime, you can manually create /dev/mdX nodes with mknod, just 
> as you would have done before. Once the array is created, if you have it 
> set to auto-start (using 0xfd partition types), it the device node will 
> automatically appear when you boot your system. If you don't have it set 
> to auto-start, you'll have to add the "mknod" command to your system 
> startup scripts before trying to start the array directly.

OK, they are set to auto-start.

I wasn't sure how to use mknod. So here's what I did:

[root@dude dev]# mknod --help
Usage: mknod [OPTION]... NAME TYPE [MAJOR MINOR]
Create the special file NAME of the given TYPE.

   -Z, --context=CONTEXT   set security context (quoted string)
Mandatory arguments to long options are mandatory for short options too.
   -m, --mode=MODE   set permission mode (as in chmod), not a=rw - umask
       --help     display this help and exit
       --version  output version information and exit

Both MAJOR and MINOR must be specified when TYPE is b, c, or u, and they
must be omitted when TYPE is p.  If MAJOR or MINOR begins with 0x or 0X,
it is interpreted as hexadecimal; otherwise, if it begins with 0, as octal;
otherwise, as decimal.  TYPE may be:

   b      create a block (buffered) special file
   c, u   create a character (unbuffered) special file
   p      create a FIFO

Report bugs to <bug-coreutils@gnu.org>.
[root@dude dev]# mknod /dev/md2 b
mknod: when creating special files, major and minor device
numbers must be specified
Try `mknod --help' for more information.
[root@dude dev]# ls /dev/md1
/dev/md1
[root@dude dev]# file /dev/md1
/dev/md1: block special (9/1)
[root@dude dev]# file /dev/md0
/dev/md0: block special (9/0)
[root@dude dev]# file /dev/md5
/dev/md5: block special (9/5)
[root@dude dev]# mknod /dev/md2 b 9 2
[root@dude dev]# ls /dev/md2
/dev/md2

Done!

Thanks,

R.

