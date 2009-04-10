From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 13:45:00 -0700
Message-ID: <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Great, for every bit of nudge forward I end up a step or two back. Not I have to figure out this copy stuff. Is there any easy way
to do some sort of compair after cp/rsync to see if/what was missed? Creating yet another botable disk to get the copy over to the
array would be a bit of a pain. Might be easyer to pull the hda from one computer, stick it in another or usb case and copy to a
temp storage area. on the other computer. Then put the drive back and copy from the temp storage to the array over then network.
Nether computer has any ftp or web servers or a desktop. The older computer with the 3 sata drives does have mysql installed because
I started to mess with setting up mythtv but never finished.


As for the other reply, the sata drives each have 3 primary partitions all set to type fd and formated with ext3. I was going to try
ext4 for the main storage of the newer system but I found there is a problem with kernels .27 and newer on nforce2 and newer boards.
some sort of problem with the bios and apci. How do I find out which superblocks version is used?

----- Original Message ----- 
From: "Robin Hill" <robin@robinhill.me.uk>
To: <linux-raid@vger.kernel.org>
Sent: Friday, April 10, 2009 12:53 PM
Subject: Re: Converting system to raid

On Fri Apr 10, 2009 at 12:22:44PM -0700, Timothy D. Lenz wrote:

> How can cp not work? every guide I found used ether cp or rsync. Even
> guides on seting up an auto backup system use cp or rsync.
> Seems the only files/folders that shouldn't get copied are the block
> device ones that are created at boot and are not really on the drive.
>
They'll all get copied, but you won't necessarily get the correct
contents.  Because the system is in use:
 - files will be being written, so you'll either get a partial copy, or
   an old version.
 - files may be locked, so you won't be able to copy them.

Doing a backup of a running system using cp/rsync will work fine for a
lot of things (especially for config files, documents, etc) but will
almost certainly fail miserably for some (databases for example).

HTH,
    Robin
-- 
     ___
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

On Fri Apr 10, 2009 at 11:10:30AM +0200, KwangErn Liew wrote:

>
> Timothy D. Lenz wrote:
>> Ended with warning: unable to open an initial console. I was able to
>> scroll back and didn't really see any errors. Don't know if I
>> missed a change to some config file or something else that should be built
>> into the kernel. I have gone over a lot of "guides" and
>> don't see what is missing.
>
> FYI, I've never been successful in booting RAID without initrd even though
> all necessary modules are built-in. I guess mdadm.conf requires initrd to
> kick start?
>
There's no problems booting RAID without initrd - you'll need to make
sure that you're using partitions (rather than whole disks) with type
0xFD, and that the array itself is using version 0.9 superblocks
(otherwise the kernel auto-assembly will fail).

Cheers,
    Robin
-- 
     ___
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

