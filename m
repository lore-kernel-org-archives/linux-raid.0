From: Michal Soltys <soltys@ziu.info>
Subject: Re: Odd booting problem
Date: Mon, 10 Oct 2011 20:11:35 +0200
Message-ID: <4E933557.1040909@ziu.info>
References: <4E8F8C63.1080600@gmail.com> <4E9316F8.7040800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E9316F8.7040800@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11-10-10 18:02, maurice wrote:
>
>> Created the mdadm.conf file:
>> mdadm --detail --scan > /etc/mdadm.conf
>>
>> from root=/dev/sdb2 to root=/dev/md1
>>
>> dracut Warning: No root device "block: /dev/md1" found.
>>
>> And a few seconds later we get a kernel panic.
>>
>
> Is there anyone here interested in helping me with this?
>
>

Well, dracut (currently, I have some big changes staged for submission, 
but for a bit later) will do forced assembly (if no root can be found 
after a few udev loops), so technically degraded arrays you created are 
not likely the reason.

If I'm to guess the cause, it's probably naming - modern mdadm /will 
not/ export device names to the file, and leaves that for udev - and by 
default udev will use decreasing minor numbers, starting with 127. Don't 
expect the same (minor number ~ device) relations during next bootings 
either.

Try this - get the UUID of actual filesystem, and change the boot 
commandline to something with root=UUID=<uuid>

You can get the uuid with e.g.

blkid -o udev <device>

and use the ID_FS_UUID_ENC value. Or peek into /dev/disk/by-uuid and get 
the value from there. You can also use LABEL, and quite a few other 
alternatives. dracut is pretty felxible.

Another possibility, is to create (or update) the array's name, and use 
/dev/md/<name> for root= which should work just fine as well (with sane 
udev rules and modern mdadm, /dev/md/ should contain array specific name 
symlinked to proper /dev entry ).

If the above fails, then there's some other reason lurking.

Btw, what version of dracut are you using ? Anything relatively current 
should drop you into emergency shell, not end with kernel panic.

Btw2: stock md rules (3.2.x) will try to assemble anything as udev goes. 
If you want to limit the assembly to something specific, use mdadm.conf 
with:

AUTO -all
ARRAY ....

see mdadm.conf(5) for details.
