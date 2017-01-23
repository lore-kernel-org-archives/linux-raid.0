From: "John Stoffel" <john@stoffel.org>
Subject: Re: Input/Output error reading from a clean raid
Date: Mon, 23 Jan 2017 12:07:02 -0500
Message-ID: <22662.14390.551624.557189@quad.stoffel.home>
References: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
        <20170123010334.GA7546@metamorpher.de>
        <CAGmni9pazRfia++-s5Hn4FT+ubVzEhsnrQrKC3cSLja53-SizQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9pazRfia++-s5Hn4FT+ubVzEhsnrQrKC3cSLja53-SizQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Salatiel" == Salatiel Filho <salatiel.filho@gmail.com> writes:

Salatiel> Ok, i have run echo check >>/sys/block/md1/md/sync_action,
Salatiel> and now the output of mdadm mdadm --examine-badblocks
Salatiel> /dev/sdd1 /dev/sdg1 /dev/sdf1 /dev/sde1


Salatiel> Bad-blocks on /dev/sdd1:
Salatiel>           1515723072 for 512 sectors
Salatiel>           1515723584 for 512 sectors
Salatiel>           1515724096 for 512 sectors
Salatiel>           1515724608 for 512 sectors

You have bad disks in your array.  First thing off is that I would go
buy replacements and then use 'ddrescue' to copy the data from the old
disks to new disks.  Then I'd try to assemble the NEW disks only into
an array, and then I'd fsck the filesystem(s).

You're going to lose data, no doubt about it.  You're now in the mode
where you're trying to save as much as you can as quickly as possible.

Personally, I'd be setting up a RAID6 array for your new setup.  Then
I would also be setting up weekly checks of the raid array as well.

You're going to lose data no matter what.  So get new disks and start
copying what you can.

John
