From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Why does one get =?UTF-8?Q?mismatches=3F?=
Date: Thu, 21 Jan 2010 15:17:56 +1100
Message-ID: <968ea7bde37a4085f4588f2ef4447d94@localhost>
References: <387070.15704.qm@web51305.mail.re2.yahoo.com> <hj77p7$rsr$1@ger.gmane.org> 	<70ed7c3e1001201244k3c734336y8e145bb50f88de26@mail.gmail.com> 	<hj7vta$nvq$1@ger.gmane.org> <70ed7c3e1001201430i72023a9fq1341b671073ac53c@mail.gmail.com> <hj80v1$rap$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hj80v1$rap$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brett Russ <bruss@netezza.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 20 Jan 2010 17:43:45 -0500, Brett Russ <bruss@netezza.com> wrote:
> On 01/20/2010 05:30 PM, Majed B. wrote:
>> He needs to run a full offline or long test before checking with
>> smartctl -a -- since it won't show any sector errors if those tests
>> weren't run at least once.
> 
> Not sure I agree with that.  The md checks he's been doing will cause a 
> read of all data regions of the relevant partition and if the disk is 
> throwing errors, those sectors should be marked probational.  Then, if a

> subsequent repair ends up remapping them, those sectors will show up as 
> remapped.
> 
> The grep will show both probational and remapped sector counts for each 
> drive.
> 
> BTW, the cmd should also include an echo so it's easy to tell which 
> drive is being reported:
> 
> for di in a b c d e f g; do echo $di; smartctl -a /dev/sd$di | grep -i 
> _sect; done

Interestingly enough, I'm struggling with a system on this matter too... I
can never seem to get rid of mismatches.

# for di in a b c d e f g; do echo $di; smartctl -a /dev/hd$di | grep -i
sect; done
a
=== START OF INFORMATION SECTION ===
=== START OF READ SMART DATA SECTION ===
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always  
   -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always  
   -       0
b
c
=== START OF INFORMATION SECTION ===
=== START OF READ SMART DATA SECTION ===
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always  
   -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always  
   -       0

Full offline tests of both drives less than 400 power on hours ago all
came up clean. No read errors. Just mismatches.

I can run a repair on them and STILL have mismatches again after a check.
At the moment:

# cat /sys/block/md2/md/mismatch_cnt
1024

It's in the middle of a repair now - as quite often the filesystem on
/dev/md2 will go read-only due to a journal error. I've tried everything
except replacing hardware to figure out what's going on here - but it will
do this like clockwork every month. A reboot later and it'll run an fsck,
find no errors, then between 21 and 30 days later it will go readonly
again.

It's annoying as hell and I wish I could get to the bottom of it!

-- 
Steven Haigh
 
Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
