From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: create raid5 with missing disk; not possible?
Date: Fri, 14 Jan 2005 18:08:36 -0500
Message-ID: <200501142306.j0EN6f912224@www.watkins-home.com>
References: <41E8487E.4090507@avz.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E8487E.4090507@avz.xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: 'Ferenc-Jan' <ferenc@avz.xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maybe your mdadm V1.8.1 is an issue!
It is an experimental version.
Try version 1.8.0.

Yes, 2 IDE disks are fine, until one fails!
Then it will be a pain in the @$$.

If 666 scares you, do this to verify your speed.  :)
grep "CPU clock" /var/log/dmesg

I bet it is closer to 663 MHz.  :)

You should trust Mr. Brown!  He knows all, well, knows most! :)

I have never seen a "0 0 0 sync" before.  It does seem wrong.
What does /proc/mdstat have?

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ferenc-Jan
Sent: Friday, January 14, 2005 5:33 PM
To: Guy; linux-raid@vger.kernel.org
Subject: Re: create raid5 with missing disk; not possible?

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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

