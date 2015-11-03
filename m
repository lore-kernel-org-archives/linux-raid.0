From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested
Date: Mon, 2 Nov 2015 23:47:32 -0500
Message-ID: <56383C64.2070807@turmel.org>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
 <56367C33.6060703@turmel.org>
 <CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
 <5637842D.1070000@turmel.org>
 <CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
 <5637BCE4.8000006@turmel.org>
 <CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
 <5637FBAC.8000900@turmel.org>
 <CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
 <56380690.5030600@turmel.org>
 <CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>
 <56381406.7070608@turmel.org>
 <CAPpdf59EV2TfpHUiZghAfWW6qy5je686Hg_qAs4xLchrUa=G7w@mail.gmail.com>
 <5638336E.4030400@turmel.org>
 <CAPpdf5-DMFrKRiBXjstJkvqQU1KzqJoL=hfNVqTGjy2HfMcALQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf5-DMFrKRiBXjstJkvqQU1KzqJoL=hfNVqTGjy2HfMcALQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/02/2015 11:28 PM, o1bigtenor wrote:
> gdisk
> 
> n 1 2048 1923518592
> 
> Will that change any of the data on the sectors?
> 
> Please - - - is there any way of getting specific commands?

gdisk /dev/md0

{Yes, you put /dev/md0 on the gdisk command line.}

then select 'n' for new partition.  It should offer to create partition
#1.  It should offer 2048 as the starting sector.  It should offer the
last legal sector as the ending sector.  It will probably assign type
8300 by default too.  All good.  Just make sure it *does* get the
starting sector right (2048).

When it gives you its prompt again, select 'p' to print it out so you
can double check.  Then select 'w' to write the new partition table.  It
will warn you, but yes you are sure (as long as the start sector is 2048).

You will end up back at the shell prompt.  You may or may not have seen
a partition device name in the messages.  If not, use "partprobe /dev/md0".

Finally, use "dmesg |tail" to see the last few kernel messages -- the
new device name should show up there.  Or use "blkid" to see all known
partition names.

Whatever name it is, fsck it with the '-n' option.

Then mount it.

Then make backups.

Phil
