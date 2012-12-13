From: "Andris Berzins" <pkix@inbox.lv>
Subject: Re: failed raid re-create changed dev size
Date: Thu, 13 Dec 2012 18:13:54 +0200
Message-ID: <1355415234.50c9fec2e9592@mail.inbox.lv>
References: <1355328659.50c8ac93db8a3@mail.inbox.lv>
 <20121213093040.GA17294@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121213093040.GA17294@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting "Robin Hill" <robin@robinhill.me.uk>:
> On Wed Dec 12, 2012 at 06:10:59PM +0200, Andris Berzins wrote:
> 
>>>> Is it possible that no data was damaged? It is LUKS partition, i
>>>> mapped it and run "fsck -n" on underlying ext3 partition,
>>>> but fsck returned immediately with status "clean".
>>>> 
>>> By default fsck will just check whether the filesystem is marked as
>>> dirty/clean and just skip running if it's clean. You'll need to use "-f"
>>> to force it to run.
>> 
>> It seems that something got damaged. I have several traces as shown
>> below in dmesg.
>> 
>> Tried to run "fsck -f -n" but it looks that it will take several month
>> on this 15TB fs with billion files.
>> Any ideas?
>> 
> Sorry, no. You've got a corrupted filesystem and fsck is the tool to fix
> that. If you're certain that the array is now set up correctly (which it
> probably is if LUKS is able to map it okay), then you can skip the "-n"
> pass and proceed straight to repair. Depending on memory, you may also
> want to look into setting up scratch_files in e2fsck.conf as it can suck
> up a lot of memory for large filesystems. You may also want to look into
> moving to ext4 once you've got the filesystem fixed - fsck times should
> be much lower than with ext3.

Thank you for suggestions!
fsck finished sooner than I thought. :)
Very interesting. Turns out that this raid recreation with wrong offset did not damage underlying file system?

# fsck -f -n /dev/mapper/data
fsck from util-linux 2.20.1
e2fsck 1.42 (29-Nov-2011)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/mapper/data: 121432484/457854976 files (0.1% non-contiguous), 2827329571/3662830720 blocks




> 
> The only other option would be to reformat and restore from backup.
> 
> Good luck,
> Robin
> --
> ___
> ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
> / / )      | Little Jim says ....                            |
> // !!       |      "He fallen in de water !!"                 |

