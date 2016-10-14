From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 19:38:31 +0200
Message-ID: <58011817.5@bluewin.ch>
References: <5800AE09.70608@bluewin.ch>
 <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org>
 <003401d22635$32b7bc70$98273550$@wnsdev.com> <580107FA.40901@bluewin.ch>
 <005501d22640$fc4d6a20$f4e83e60$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005501d22640$fc4d6a20$f4e83e60$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/10/16 19:32, Peter Sangas wrote:
> Do you know why some of your mds were created with bitmaps and others were not?  When I installed Ubuntu 16.04 and used the installer to create a RAID1 some of the mds had bitmaps and some did not.

Yes, I do. Phil Turmel answer my initial question:

On 14/10/16 13:53, Phil Turmel wrote:
 > Bitmaps have been available for a long time, but including them on a
 > new array by default is recent.

http://marc.info/?l=linux-raid&m=147644598622369&w=2


You can remove the bitmap while the RAID is running with

# mdadm -G /dev/md5 -b none

or add it with

# mdadm -G /dev/md5 -b internal


Regards,
Ramon
