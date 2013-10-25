From: Dag Nygren <dag@newtech.fi>
Subject: Re: Help raid10 recovery from 2 disks removed
Date: Fri, 25 Oct 2013 10:27:42 +0300
Message-ID: <2614300.keHkAfZ48K@eseries.newtech.fi>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net> <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net> <alpine.DEB.2.02.1310241441280.1838@uplift.swm.pp.se>
Reply-To: dag@newtech.fi
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1310241441280.1838@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: yuji_touya@yokogawa-digital.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 24 October 2013 14:44:14 Mikael Abrahamsson wrote:
> On Thu, 24 Oct 2013, yuji_touya@yokogawa-digital.com wrote:
> 
> > Here's syslog entries about raid10 and smartctl output.
> > sdb seems to have too many bad blocks. Is that the reason why sdb was kicked out?
> 
> Most likely.
> 
> > I'm going to copy files from /dev/md0 to anywhere else as soon as possible.
> > Should I repair filesystem before copying? (like xfs_repair /dev/md0)
> 
> What you need to do now is to use dd_rescue or equivalent to copy the data 
> off of sdb to a good drive. Stop the array first. This means you'll lose 
> data on the bad blocks. After this is done, and you have assembled the 
> array with the good drive with (most of) the data from sdb, start the 
> array, then hot-add in sdc and let things sync up. You should now have 
> redundancy.

all!

Just had a fight with this myself, also using Seagate drives.
And I don't think he needs to loose any data, nor use ddrescue here.

Just enabling scterc (which is disabled by default and will be
after a power down of the drive), setting the timeout 
and then running a repair on the array
fixed it for me as md was smart enough to try to rewrite the
sector(s) that had failed and with scterc the drive would then reallocate
the failed sector. 
I thought I had this done, but a syntax error in the script had
prevented it from working.. :-( )

The working script I ran for this was:
=============================
# Set up RAID drive timeouts
for x in b c d e
do
        smartctl -l scterc,70,70 /dev/sd$x
        echo 180 >/sys/block/sd$x/device/timeout
done
==============================

After taht run "echo "repair" >/sys/block/md0/md/sync_action"

This should move the 112 count for your "Pending" sectors to "Reallocated_Sector_Ct"
in the smartctl output and fix your array.
After that again you should readd the drive that has been missing almost since
the initialization of the array and keep a close eye on the error counts there.

You should also keep an eye on the Reallocated_Sector_Ct for sdb though.
Your 112 is still below the health limit for Seagate's (200), but it is
fairly high and indicates a "not so good" drive.
If the count goes over 200 Seagate will replace the drive.

If someone with more insight has objections to the procedure above, please
tell me. But this worked for me.

> Also check why you didn't get notification that sdc wasn't part of the 
> array, usually mdmon or equivalent will send email about these events.

Good advice! Set up the smartctl email address!

Best
Dag

