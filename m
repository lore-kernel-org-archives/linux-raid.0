From: Ferenc-Jan <ferenc@avz.xs4all.nl>
Subject: Re: create raid5 with missing disk; not possible?
Date: Fri, 14 Jan 2005 23:32:30 +0100
Message-ID: <41E8487E.4090507@avz.xs4all.nl>
References: <200501142103.j0EL3d911716@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501142103.j0EL3d911716@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:

> It should work!

I certainly hope so! :-)

> I used your example, and everything worked as expected.
> mdadm -C /dev/md3 -R -l5 -n4 /dev/ram0 /dev/ram1 /dev/ram2 missing

And I used your example, even literally pasted it, but strangely, I get 
from mdadm -D /dev/md3:

     Number   Major   Minor   RaidDevice State
        0       1        0        0      active sync   /dev/ram0
        1       1        1        1      active sync   /dev/ram1
        2       1        2        2      active sync   /dev/ram2
        3       0        0        0      sync

This on two different machines even. -R or not did not make a 
difference. That last line is not good, is it? Mr. Brown wrote that to 
me a few weeks back.

Using /dev/hd[a,c,d]3 yields the same results (3 0 0 0 sync). I did do 
mdadm --zero-superblock /dev/hd[a,c,d]3.

And yeah, I know using two drives on one ide channel is a not advisable. 
But it is supported, isn't it? Anyway,

mdadm -C /dev/md3 -l5 -n3 /dev/hda3 /dev/hdc3 missing

produces (mdadm -D /dev/md3):

      Number   Major   Minor   RaidDevice State
        0       3        3        0      active sync   /dev/hda3
        1      22        3        1      active sync   /dev/hdc3
        2       0        0        0      sync

This is mdadm - v1.8.1 - 05 November 2004, slackware linux 9.1 kernel 
2.4.22, run-of-the-mill 40gb harddisks on a 666mhz p-III. That MHz 
number might be an omen.

Thanks for the swift replies.

cheers

Ferenc
