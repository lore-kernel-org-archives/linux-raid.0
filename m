From: Phil Turmel <philip@turmel.org>
Subject: Re: Mounting array at boot - works with some kernels but not others
Date: Sun, 03 Apr 2011 13:41:10 -0400
Message-ID: <4D98B136.1010803@turmel.org>
References: <BANLkTinSwLgNze-EdRB6wu1o5QYApHbLXQ@mail.gmail.com>	<4D98AAD3.2050700@turmel.org> <BANLkTimogoGPhRCq-+aT=TobByyp4fdfAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimogoGPhRCq-+aT=TobByyp4fdfAA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dennis Grant <reccedg@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/03/2011 01:26 PM, Dennis Grant wrote:
> On Sun, Apr 3, 2011 at 1:13 PM, Phil Turmel <philip@turmel.org> wrote:
> 
>> On-list is fine.  A couple of clarifications below:
> 
>> Please do "mdadm --examine" on the component devices /dev/sda5 and /dev/sdb5.
> 
> As requested:
> 
> sudo mdadm --examine /dev/sda
> mdadm: No md superblock detected on /dev/sda.
> 
> sudo mdadm --examine /dev/sdb
> mdadm: No md superblock detected on /dev/sdb.
> 

Hmmm.  This means that the metadata location is *not* ambiguous, or it would show for the examine of both the whole device and the partition.  So much for that idea.

>> Please also share the output of "blkid" so we can interpret this fstab.
> 
> sudo blkid
[snip /]
> /dev/md1: UUID="cdd97ad2-e070-477b-b649-83921f70b9cf" TYPE="ext3"

This is what I wanted, but I'm a dunce.  You called out /dev/md1 directly in the fstab.  Sorry.

>> I suspect that the new kernels are noticing your version 0.90 metadata and trying to be conservative.  0.90 metadata can be ambiguous when on the last partition of a disk (same location and content as if for the whole disk).
> 
>> You can remove the ambiguity by declaring in mdadm.conf that devices to inspect must be partitions, like so:
>>
>> DEVICE /dev/sd*[0-9]
>>
>> Or call them out explicitly:
>>
>> DEVICE /dev/sda5 /dev/sdb5
> 
> Here's the current version:
> 
> cat /etc/mdadm/mdadm.conf
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
> 
> # by default, scan all partitions (/proc/partitions) for MD superblocks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE /dev/sda5 /dev/sdb5
> 
> # auto-create devices with Debian standard permissions
> CREATE owner=root group=disk mode=0660 auto=yes
> 
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
> 
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR root
> 
> # definitions of existing MD arrays
> ARRAY /dev/md1 devices=/dev/sda5,/dev/sdb5
> 
> -------------------------
> So it looks like they are already called out.

Yup.  Blind alley.

You mentioned that the system will boot with a newer kernel, just without the array.  Could you boot it like that, but select single-user mode?  Then you can save the dmesg to a file, collect any other useful messages, reboot into 2.6.31, then paste the files into an email.

Phil
