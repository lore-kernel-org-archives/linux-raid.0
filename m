From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recovering RAID5 from multiple disk failures
Date: Sat, 2 Feb 2013 13:20:12 -0700
Message-ID: <B7E27E99-9C89-4FC5-A12D-EFFAB5EDE5EB@colorremedies.com>
References: <kegcd6$6dl$1@ger.gmane.org> <510BC173.7070002@turmel.org> <kej2t8$vk8$1@ger.gmane.org> <510D184E.4070106@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510D184E.4070106@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Michael Ritzert <ksciplot@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Feb 2, 2013, at 6:44 AM, Phil Turmel <philip@turmel.org> wrote:
> 
> All of your drives are in perfect condition (no relocations at all).

One disk has Current_Pending_Sector raw value 30, and read error rate of 1121.
Another disk has  Current_Pending_Sector raw value 2350, and read error rate of 29439.

I think for new drives that's unreasonable. 

It's probably also unreasonable to trust a new drive without testing it. But some of the drives were tested by someone or something, and the test itself was aborted due to read failures, even though the disk was not flagged by SMART as "failed" or failure in progress. Example:

# 1  Short offline       Completed: read failure       40%       766         329136144
# 2  Short offline       Completed: read failure       10%       745         717909280
# 3  Short offline       Completed: read failure       70%       714         327191864
# 4  Extended offline    Completed: read failure       90%       695         329136144
# 5  Short offline       Completed: read failure       80%       695         724561192

Almost 100 hours ago, at least, problems with this disk were identified. Maybe this is a NAS feature limitation problem, but if the NAS is going to purport to do SMART testing and then fail to inform the user that the tests themselves are failing due to bad sectors, that's negligence in my opinion. Sadly it's common.

These NAS products should have an option to test the drives: secure erase them, do long extended tests, make sure they finish, make sure they don't have sector pending errors, report to the user sector pending errors and what to do about it.

Otherwise, it's a crap product. The knowledge is available, the tools are there, the product just isn't using them.


> Based on the event counts in your superblocks, I'd say disk1 was kicked out long ago due to a normal URE (hundreds of hours ago) and the array has been degraded ever since.

I'm confused because the OP reports disk 1 and disk 4 as sdc3, disk 2 and disk 3 as sdb3; yet the superblock info has different checksums for each. So based on Update Time field, I'm curious what other information leads you to believe disk1 was kicked hundreds of hours ago:

disk 1:
Fri Jan  4 15:11:07 2013
disk 2:
Fri Jan  4 16:33:36 2013
disk 3:
Fri Jan  4 16:32:27 2013
disk 4:
Fri Jan  4 16:33:36 2013

Nevertheless, over an hour and a half is a long time if the file system were being updated at all. There'd definitely be data/parity mismatches for disk1.

If disk 1 is assumed to be useless, meaning force assemble the array in degraded mode; a URE or linux SCSI layer time out is to be avoided or the array as a whole fails. Every sector is needed. So what do you think about raising the linux scsi layer time out to maybe 2 minutes, and leaving the remaining drive's SCT ERC alone so that they don't time out sooner, but rather go into whatever deep recovery they have to in the hopes those bad sectors can be read?

echo 120 >/sys/block/sdX/device/timeout

I'm seeing from the SMART data, even though there are disks that have bad sectors, there are NO hardware ECC recovered events. So I don't know that we know those sectors are totally lost causes yet. If they are, seems like the array is toast unless disk 1 can somehow be included.



> Meaning that all of your troubles are due to timeout mismatch, lack of
> scrubbing (or timeout error on the first scrub), and lack of backups.
> Aim your disappointment elsewhere.

I tentatively agree. This is a case of maybe not the best drives out of the box, a contributing factor certainly is that they have bad sectors on arrival. Not good. Combine that with a NAS that doesn't properly set the SCT ERC on any of the drives. Combine that with whoever or whatever did the offline tests but did not report the aborts due to read failures to the user.

It's a collision of multiple "not good" events.

For a normal, non-degraded array, I read man 4 md to mean either a check or repair would "fix" bad sectors resulting in UREs: i.e. whether a data chunk or parity chunk, the URE'd sector will be overwritten with correct data.

But what about --assemble --force where --assume-clean isn't accepted? Does this involve "check" behavior, or is the ensuing resync assuming data chunks are valid and parity chunks invalid (subject to being overwritten with recomputed parity)? If so, then what happens with a data chunk URE? Can this resync repair that?

Chris Murphy

