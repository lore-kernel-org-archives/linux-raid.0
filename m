From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: migrating from metadata 0.9 to 1.0 before growing?
Date: Fri, 24 Feb 2012 11:38:21 +0100
Message-ID: <20120224113821.c2b14f48bcf7e6809b2cd3a6@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there.

I have a RAID6 using disks in an external SATA enclosure.
Now I started to exchange the disks with others twice as big as the ones the
RAID was originally created with.
The RAID uses metadata version 0.9.

Now I'm thinking about switching to format 1.0 this way:

* exchange all disks with the bigger ones piece by piece
  (-f old -r old -a new)
* wait for rebuild of last disk
* recreate RAID with --assume-clean and --metadata 1.0 and the same disks in
  the correct order

The --grow shouldn't be necessary this way.
Then I grow the filesystem.

Is this precedure possible without data loss?
Or is there a way a metadata version migration could be done more easily?

Thanks
Lars
