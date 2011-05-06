From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: 6-drive RAID 10 failed, cannot reactivate, need help
Date: Fri, 6 May 2011 16:40:58 -0500
Message-ID: <75.AA.16951.5EA64CD4@cdptpa-omtalb.mail.rr.com>
References: <BANLkTinz6bkqM+z7ddXZTOXFqjFHsEfEHw@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinz6bkqM+z7ddXZTOXFqjFHsEfEHw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: fibreraid@gmail.com, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of fibreraid@gmail.com
> Sent: Monday, May 02, 2011 1:17 PM
> To: linux-raid
> Subject: 6-drive RAID 10 failed, cannot reactivate, need help
> 
> Hi All,
> 
> I have an Ubuntu Hardy 64-bit system with mdadm 2.6.9.
> 
> I have a 6-drive RAID 10 named md1. Unfortunately, there was some
> power outage and when the system came back up, it showed 2 drives as
> failed and 4 as active. I removed the two failed drives from the array
> using -r, and then added them back in using --add and --force. The

	Ooh, that's bad.

> array will not rebuild though. It simply shows now these two drives as
> spares.
> 
> I doubt the data is actually lost since it was a sudden outage. What
> can I do from here to get mdadm to activate this array and kick off
> rebuild if needed? I'm really stuck. Thanks in advance for any help.

	First of all, I heartily suggest you copy at least the failed drives
and if possible all 6 drives to spare hard drives using dd_rescue.  After
that, you are going to need to re-create the array.  Make sure all the
parameters are the same as the original, including superb;ock, chunk size,
bitmap, and position within the array.  Essentially, allowing for any
differences in drive position and any growth or re-shaping of the array, you
need to re-issue the same command originally issued to create the array,
except use the --assume-clean switch so md won't try to re-sync.  Mount the
file system ready-only and attempt to read it.  If it fails, stop the array,
determine which element is incorrect, and try again.

