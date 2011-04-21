From: David Brown <david.brown@hesbynett.no>
Subject: Re: Server =?UTF-8?B?ZG93bi1mYWls4oCLZWQgUkFJRDUtYXNraW5nIGZvciBz?=
 =?UTF-8?B?b21lIGFzc2lzdGFuY2U=?=
Date: Thu, 21 Apr 2011 21:59:36 +0200
Message-ID: <ioq2b8$3rl$1@dough.gmane.org>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/04/11 20:29, John Valarti wrote:
> Hi there.
> Please pardon my lack of experience and expertise here, as this is my
> first time posting.
>
> Where I work there is a fairly old fileserver.
> It is running CentOS 4, kernel 2.6.9-100EL
> Recently it failed and it tries to boot, but fails part way with:
> RAID5: not enough operational device for md1 (2/4 failed).
>
> This machine has data for a number of users, and, of course it seems
> the backup has not been roperly done for a few months ( responsible
> staff member left).
> I am in the position of being teh only likely person with a chance of
> recovering the data for a few users on this machine.
> And I am certainly NOT an expert!
>
> So, here is what I have done so far:
> On further inspection, I disconnected the drives out one at a time and
> determined which 2 are "failed".
> I pulled those out, and on another machine ran Seagate Seatest for
> Linux to test them.
> They both came out as healthy, although one apparently has a lot of
> uncommited bad sectors, or so the disk tool on a Fedora14 mchine tells
> me.
> I looked and see the layout is each of the 4 disks present have 2 partitions.
> After testing I was able to see the partitions on each disk with fdisk.
> I did not try to mount as these are simply RAID members, and I know
> there is no complete filesystem to mount on any single drive here.
>
> First partiton on each drive is small,  /boot, and it seems to be
> RAID1 on all 4 drives.
> Those are healthy enough to get partially into a boot.
>
> The machine still boots to the point of trying to get access to / and
> then kernel panics.
> The / and other parts are on a RAID5 made from the second partiton of
> the 4 disks.
>
> I have returned all 4 disks to the machine, and using CentOS
> install/recovery media, have teh machine up
> in rescue mode.
> At this point I believe that I need to rebuild the RAID5.
>
> I understand that I probably only get one chance to do this right, so
> I write here today
> to beg some help with this.
>   I do not lose other peoples data,
>
> Can anyone make me a suggestion?
>
>
> Thaks in advance for any help !
>

My first thought would be to get /all/ the disks, not just the "failed" 
ones, out of the machine.  You want to make full images of them (with 
ddrescue or something similar) to files on another disk, and then work 
with those images.  Don't touch the original disks - you will very 
quickly lose any chance you have of recovering your data.  But once 
you've got the images, you can copy them and try out recovery strategies 
- all it costs is some disk space and some time, and you've no risk of 
making things worse.

Once you've got some (hopefully most) of your data recovered from the 
images, buy four /new/ disks to put in the machine, and work on your 
restore.  You don't want to reuse the failing disks, and probably the 
other two equally old and worn disks will be high risk too.


