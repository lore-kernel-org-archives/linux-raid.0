From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: flummoxed why I can't umount my md device.  fuser and lsof show
 no files locked
Date: Mon, 20 Jun 2011 19:16:12 +0100
Message-ID: <4DFF8E6C.8080100@gmail.com>
References: <4DFF87F8.8050202@gmail.com> <20110621000317.156d7d27@natsu>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110621000317.156d7d27@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Roman,
Sorry for the stupid omission, I did try running umount 
/media/local/Raid to no avail.  The other thing I also tried was the 
lazy dismount option, but it never unmounted, I did a force, then 
remount and dismount, but it didn't make any difference to the errors.  
none of the processes have a working directory in the Raid folder as it 
is just for storage, the OS and apps are on a separate drive entirely.  
I also ensured that my ssh session was not in the /media/local folder 
either.

I am pretty sure that I actually want the array running in order to run 
a mkfs against it (obviously) I just tried that as a last ditch 
attempt.  I'm really just trying to figure out how I can find out what 
process has the folder locked if lsof and fuser can't tell me :-)

cheers
Simon

On 20/06/2011 19:03, Roman Mamedov wrote:
> On Mon, 20 Jun 2011 18:48:40 +0100
> Simon McNair<simonmcnair@gmail.com>  wrote:
>
>> I wanted to run 'mkfs.ext4 -n /dev/md0' to see what settings it would
>> choose that were different to mine but it keeps saying:
>> "/dev/md0 is apparently in use by the system; will not make a filesystem
>> here!".
>>
>> I also can't stop the array using 'mdadm --stop /dev/md0' as it says
>> mdadm: failed to stop array /dev/md0: Device or resource busy.  pretty
>> much the same error occurs when trying lvchange -an /media/local/Raid
>>
>> I've no problem with any of this except I can't find out what process
>> has a handle on the mount and/or why.  so I can't stop/kill it.
>>
>> I tried lsof | grep /media/local/Raid and fuser -m /media/local/Raid to
>> no avail.  I also tried ps aux | grep Raid.  I've stopped pretty much
>> everything in init.d including samba,nfs,mediatomb,squeezebox and
>> anything I can think of that I've installed.
>>
>> Any advice/ideas please ?
> I don't see you mention actually running "umount /media/local/Raid" (and
> perhaps listing the error messages you get after that). Perhaps it goes
> without saying and you did this, but in case not, remember that "mdadm --stop"
> will not try to auto-unmount the filesystem for you first.
>
> Other ideas, AFAIK lsof and fuser won't show you a process that holds the
> filesystem mounted in case it doesn't have any files open there, but instead
> just has its *current directory* on the FS. So if you launched something while
> cd'ed somewhere in /media/local/Raid, and it's still running (maybe the
> superuser shell you currently work in?), that'd be your reason.
>
> -
> With respect,
> Roman
