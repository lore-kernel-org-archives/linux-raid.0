From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: RAID5 to RAID6 reshape?
Date: Sun, 17 Feb 2008 14:31:22 +0100
Message-ID: <20080217143122.36413814@szpak>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Beolach said:     (by the date of Sat, 16 Feb 2008 20:58:07 -0700)

> I'm also interested in hearing people's opinions about LVM / EVMS.

With LVM it will be possible for you to have several raid5 and raid6:
eg: 5 HHDs (raid6), 5HDDs (raid6) and 4 HDDs (raid5). Here you would
have 14 HDDs and five of them being extra - for safety/redundancy
purposes.

LVM allows you to "join" several blockdevices and create one huge
partition on top of them. Without LVM you will end up with raid6 on
14 HDDs thus having only 2 drives used for redundancy. Quite risky
IMHO.

It is quite often that a *whole* IO controller dies and takes all 4
drives with it. So when you connect your drives, always make sure
that you are totally safe if any of your IO conrollers dies (taking
down 4 HDDs with it). With 5 redundant discs this may be possible to
solve. Of course when you replace the controller the discs are up
again, and only need to resync (which is done automatically).

LVM can be grown on-line (without rebooting the computer) to "join"
new block devices. And after that you only `resize2fs /dev/...` and
your partition is bigger. Also in such configuration I suggest you to
use ext3 fs, because no other fs (XFS, JFS, whatever) had that much
testing than ext* filesystems had.


Question to other people here - what is the maximum partition size
that ext3 can handle, am I correct it 4 TB ?

And to go above 4 TB we need to use ext4dev, right?

best regards
-- 
Janek Kozicki                                                         |
