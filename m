From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid Problem - Unknown File System Type
Date: Thu, 10 Nov 2011 11:32:26 -0500
Message-ID: <4EBBFC9A.4030103@turmel.org>
References: <4EBAA68B.6090906@rogers.com> <20111109163933.GA26630@cthulhu.home.robinhill.me.uk> <4EBAB47C.5070002@rogers.com> <4EBACC88.8070403@turmel.org> <4EBADB1E.1070700@rogers.com> <4EBADD07.5030109@turmel.org> <4EBAE90F.2030104@rogers.com> <4EBAF46C.2030001@turmel.org> <4EBB46A5.8080305@rogers.com> <4EBB4B95.6040309@turmel.org> <4EBBEC80.9040709@rogers.com> <4EBBF26B.1090309@turmel.org> <4EBBF7E3.9030803@yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBBF7E3.9030803@yuiop.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@yuiop.co.uk>
Cc: William Colls <william.colls@rogers.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/2011 11:12 AM, John Robinson wrote:
> On 10/11/2011 15:48, Phil Turmel wrote:
>> On 11/10/2011 10:23 AM, William Colls wrote: [...]
>>> the array was mounted as follows
>>> 
>>> mount -t ext3 /dev/md0p1 /opt/share
>>> 
>>> LVM was not installed on the old system, nor is it installed on
>>> the new machine
> [...]
>> If none of this works, I'm out of ideas.  You'd probably want to
>> ask for more help on the linux-ext4 mailing list.
> 
> The only thing that occurs to me is the possibility that both the md
> device was made from partitions, not whole drives, and the md device
> was itself partitioned. I wouldn't know quite how to go about
> checking though.

Great call!  I just looked back at the hexdump, and sure enough, there's a nested MBR there.  It's missing a bootloader, which threw me off, but there is a single partition defined.

William, you can thank John.

Here's what you need to do:

mdadm --stop /dev/md0
mdadm --zero-superblock /dev/sd[bc]

partx -a /dev/sdb
partx -a /dev/sdc

cat /proc/partitions
(to verify that /dev/sda1 and /dev/sdb1 are present)

mdadm --create --assume-clean /dev/md0 --level=1 -n 2 /dev/sda1 /dev/sdb1

cat /proc/partitions
(to verify that /dev/md0p1 is present)

mount ....

If you want to minimize the chance of mdadm getting confused again, you probably want v1.x metadata.  (But not just yet.  Get your data back, first.)  It includes offset information that avoids the ambiguity when v0.90 metadata is on the last partition of a disk.  Otherwise, you need to set up mdadm.conf to exclude /dev/sdb and /dev/sdc from consideration, and make sure that ends up in your initramfs.

Also, your partitions, both the outer and the nested, start with sector 63.  This is bad for performance on modern drives, as most big ones have physical 4k sectors.  After you make your backup, I suggest you recreate your entire setup from scratch, making sure alignment is appropriate, and switching to v1.1 or v1.2 metadata.

Phil
