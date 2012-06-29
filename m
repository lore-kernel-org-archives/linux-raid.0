From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Can't expand linear RAID on top of 2 x RAID1
Date: Fri, 29 Jun 2012 17:53:54 +1000
Message-ID: <4FED5F12.2020100@websitemanagers.com.au>
References: <4FE44BDD.302@websitemanagers.com.au> <4FE4FA32.8010506@hardwarefreak.com> <32a64312-93cd-47d7-9154-2e28eda58003@email.android.com> <20120625125224.6e33b342@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625125224.6e33b342@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/06/12 12:52, NeilBrown wrote:
> The is no '--assume-clean' for linear.  Linear arrays cannot be
> clean or dirty as md stores no redundant information.
> 
> Just re-creating the array would probably work, but there is an
> easier way.
> 
> md doesn't record the size of the array for Linear and RAID0.  It
> just adds together the sizes of the devices that it finds.
> 
> With 1.x metadata, md does record the effective size of each
> devices, so adds those together. You can update this effective size
> by assembling with --update=devicesize
> 
> I just checked this will loop devices and it works as expected
> (assuming you have 1.1 or 1.2 metadata). So: mdadm -S /dev/md2 
> mdadm -A --update=devicesize /dev/md0 /dev/md1
> 
> (order doesn't matter with assemble).

Hi,

Just a followup email on this to say Thank You very much for your
expert assistance, it was greatly appreciated.

> mdadm -S /dev/md2

I had some issues with this command, df showed that it was unmounted,
lsof showed nothing looking at the device nor filesystem where it was
mounted, etc... Eventually, I ran "mount" and realised I had bind
mounted a sub-directory elsewhere... Once I umounted that I could stop
the array... (Duh moment :)

> mdadm -A --update=devicesize /dev/md0 /dev/md1
I got an error that the device was in use, thankfully mdadm has the
smarts to stop me from idly shooting myself in the foot when doing
something as silly as copy & paste instructions from others without
stopping and thinking first.

I adjusted the command to the correct:
mdadm -A --update=devicesize /dev/md2 /dev/md0 /dev/md1

and got:
Size was 3907019634
Size is 3907019634
Size was 1465142752
Size is 1953515906

I then checked the array, was told the filesystem was clean, and then
resized that, and now I have the extra 250G space (just in time, I
only had 6% free space there).

So, again, thank you for your assistance, and thanks for all the work
you put into the drivers etc.

Regards,
Adam

