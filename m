From: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Subject: Re: Converting ext3 to RAID1 ...
Date: Tue, 25 Aug 2009 09:30:54 +0200
Message-ID: <b7b14cbb0908250030t46483a85udcdb933b58d0050a@mail.gmail.com>
References: <b7b14cbb0908241424i50bdcf59p35a63e4496b108ca@mail.gmail.com>
	 <54326.86.132.166.70.1251164568.squirrel@www.yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54326.86.132.166.70.1251164568.squirrel@www.yuiop.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings ...

 Thanks for the reply ...  I was a little verbose with my first mail,
and was thinking that was why I did not get a response ...

2009/8/25 John Robinson <john.robinson@anonymous.org.uk>:
> On Mon, 24 August, 2009 10:24 pm, Clinton Lee Taylor wrote:
>> http://www.issociate.de/board/post/498227/Ext3_convert_to_RAID1_....html
>>
>> Wanting to convert an already created and populated ext3 filesystem.
>>
>> I unmounted the filesystem, ran e2fsck -f /dev/sdb1 to check that the
>> current filesystem had no errors.
>> Then ran mdadm --create /dev/md0 --level=1 -n 1 /dev/sdb1 --force to
>> create the RAID1 device, answered yes to the question.
>
> This rang alarm bells for me, so I checked your link above, and apparently
> you shrunk the filesystem before doing this. If you shrink the filesystem,
> and use a metadata version that puts the metadata at the end - as you did
> by default in this case using version 0.90 - then your method is fine and
> quite safe. If you don't shrink the filesystem, which you didn't mention
> here, you'd be asking for a world of pain.
 mdadm did complain about size issues, so I did the shrink before
doing the rest of the procedure, so it seems a little safe ... Is the
metadata only in one place?  I know that a few superblocks are made in
the ext3 filesystem, for backup and speed ... Could mdadm or another
util made to be smart enough to move data out of it's way when do a
conversion like this?

> Another surer method (making no assumptions about metadata version) when
> you've two identically-sized partitions, the original and the new mirror,
> is to mdadm --create /dev/mdX --level=1 -n 1 /dev/secondpartition ; mkfs
> -t Y /dev/mdX ; mount -t Y /dev/mdX /scratch ; mount -o remount,ro /path ;
> cp -a /path/* /scratch ; umount /scratch ; sed -i~ -e
> 's?/dev/originalpartition?/dev/mdX?' /etc/fstab ; umount /path ; mount
> /path ; mdadm -add /dev/mdX /dev/originalpartition
>
> That's slightly more like what the wiki article suggests, but still not
> enough for your root filesystem or booting; they're being properly
> exhaustive on converting from a 1-drive system to a 2-drive RAIDed one,
> making sure you've no assumptions (apart from it being CentOS 5), it works
> for your root filesystem and makes sure you end up with both drives
> bootable.
 But the above method, wiki article and quite a few other links on the
internet, really go through the whole copy process and then adding the
extra drive, which really means keeping the system down for quite some
time.  I believe it to be the more recognized method, but the simple
procedure that I have used, seems quicker.

 I'm hoping to make a simple script that might be able to go through
the process, with warnings, tests and corner cases issues awareness
added, plus, with this as general knowledge, maybe mdadm would either
do the right thing every time or not be updated to kill a filesystem
when this process used ...

Thanks
Mailed
LeeT
