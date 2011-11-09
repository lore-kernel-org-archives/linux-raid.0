From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid Problem - Unknown File System Type
Date: Wed, 09 Nov 2011 13:55:04 -0500
Message-ID: <4EBACC88.8070403@turmel.org>
References: <4EBAA68B.6090906@rogers.com> <20111109163933.GA26630@cthulhu.home.robinhill.me.uk> <4EBAB47C.5070002@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBAB47C.5070002@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Colls <william.colls@rogers.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi William,

On 11/09/2011 12:12 PM, William Colls wrote:
[...]

> I thought, at the time, that I needed to do the create so that the /dev/md0 device would be created properly (new machine had no raid before).

That's the "--auto" option, which has sane defaults.

[...]

> No output from the original setup.

From what you've described so far, a likely possibility is that the original raid 1 was using metadata version 1.1 or 1.2, which put the superblock near the beginning of the disks.  The default "--create" metadata in that old version of mdadm is 0.9, as you can see in your reports.

If so, you've likely only lost a tiny bit of data at the end of the volumes where the 0.90 superblock has been written.  (I'm also going to assume that the two disks were in-sync in old box before you moved them, so the re-sync wouldn't do any harm.)

A dump of the first 8K of your drives might be helpful here.

dd if=/dev/sdb count=16 2>/dev/null |hexdump -C

dd if=/dev/sdc count=16 2>/dev/null |hexdump -C

Regards,

Phil
