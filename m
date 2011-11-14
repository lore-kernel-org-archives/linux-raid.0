From: William Colls <william.colls@rogers.com>
Subject: Re: Raid Problem - Unknown File System Type
Date: Mon, 14 Nov 2011 10:01:31 -0500
Message-ID: <4EC12D4B.3050407@rogers.com>
References: <4EBAA68B.6090906@rogers.com> <20111109163933.GA26630@cthulhu.home.robinhill.me.uk> <4EBAB47C.5070002@rogers.com> <4EBACC88.8070403@turmel.org> <4EBADB1E.1070700@rogers.com> <4EBADD07.5030109@turmel.org> <4EBAE90F.2030104@rogers.com> <4EBAF46C.2030001@turmel.org> <4EBB46A5.8080305@rogers.com> <4EBB4B95.6040309@turmel.org> <4EBBEC80.9040709@rogers.com> <4EBBF26B.1090309@turmel.org> <4EBBF7E3.9030803@yuiop.co.uk> <4EBBFC9A.4030103@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBBFC9A.4030103@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Robinson <john.robinson@yuiop.co.uk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


First let ma apologise for the long silence. I wanted to take a "minute" 
to think carefully about how to proceed to maximize my chances of 
getting a good out come.

Having said that, the outcome was all that I could have hoped for and 
more. I have recovered the array, and all the data seems to be complete 
and in tact. Thank you all most sincerely for you thoughtful and helpful 
replies. Without your interest, I would have lost everything. Again 
thank you for all your assistance. Once again, the open source community 
shows itself to be the greatest place to be in the computer world, and I 
feel privilaged to be able to stand at the edge, and try to be part of it.

Thanks all.

On 11/10/2011 11:32 AM, Phil Turmel wrote:
> On 11/10/2011 11:12 AM, John Robinson wrote:
>> On 10/11/2011 15:48, Phil Turmel wrote:
>>> On 11/10/2011 10:23 AM, William Colls wrote: [...]
>>>> the array was mounted as follows
>>>>
>>>> mount -t ext3 /dev/md0p1 /opt/share
>>>>
>>>> LVM was not installed on the old system, nor is it installed on
>>>> the new machine
>> [...]
>>> If none of this works, I'm out of ideas.  You'd probably want to
>>> ask for more help on the linux-ext4 mailing list.
>>
>> The only thing that occurs to me is the possibility that both the md
>> device was made from partitions, not whole drives, and the md device
>> was itself partitioned. I wouldn't know quite how to go about
>> checking though.
>
> Great call!  I just looked back at the hexdump, and sure enough, there's a nested MBR there.  It's missing a bootloader, which threw me off, but there is a single partition defined.
>
> William, you can thank John.
>
> Here's what you need to do:
>
> mdadm --stop /dev/md0
> mdadm --zero-superblock /dev/sd[bc]
>
> partx -a /dev/sdb
> partx -a /dev/sdc
>
> cat /proc/partitions
> (to verify that /dev/sda1 and /dev/sdb1 are present)
>
> mdadm --create --assume-clean /dev/md0 --level=1 -n 2 /dev/sda1 /dev/sdb1
>
> cat /proc/partitions
> (to verify that /dev/md0p1 is present)
>
> mount ....
>
> If you want to minimize the chance of mdadm getting confused again, you probably want v1.x metadata.  (But not just yet.  Get your data back, first.)  It includes offset information that avoids the ambiguity when v0.90 metadata is on the last partition of a disk.  Otherwise, you need to set up mdadm.conf to exclude /dev/sdb and /dev/sdc from consideration, and make sure that ends up in your initramfs.
>
> Also, your partitions, both the outer and the nested, start with sector 63.  This is bad for performance on modern drives, as most big ones have physical 4k sectors.  After you make your backup, I suggest you recreate your entire setup from scratch, making sure alignment is appropriate, and switching to v1.1 or v1.2 metadata.
>
> Phil
>


-- 
I know you believe that you understand what you think I said, but I am 
not sure that you realize that what you heard was not what I meant.
