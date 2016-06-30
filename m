From: Phil Turmel <philip@turmel.org>
Subject: Re: Assembly of RAID6 with 48 disk fails
Date: Thu, 30 Jun 2016 17:06:42 -0400
Message-ID: <70dae6c2-0137-8436-0625-7a056ddf2779@turmel.org>
References: <1407524886.20708095.1467300814680.JavaMail.zimbra@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1407524886.20708095.1467300814680.JavaMail.zimbra@desy.de>
Sender: linux-raid-owner@vger.kernel.org
To: "Grunewald, Soeren" <soeren.grunewald@desy.de>, linux-raid mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/30/2016 11:33 AM, Grunewald, Soeren wrote:
> Hi All,
> 
> After a crash, probably caused by some raid issue, the array can't be 
> assembled again. It looks like 8 disk were disappearing form the raid at 
> the same time, which then lead to the system crash. Now I'm unable to 
> get the array back to live again. Because the whole system was on the 
> failing array, I can't access any additional information to check what 
> happened. The system is a 8 year old SUN Fire X4540 system running under 
> Ubuntu 12.04.5 (kernel-3.13.0-91 and mdadm-3.2.5-1ubuntu0.3), which is 
> mainly used for data conversion (converting very large files from one 
> format into another). The boot partition is placed on a 2GB ssd and the 
> rest is running on the 48disk raid6 array. I have booted the system from 
> a usb stick with clonezilla (kernel 4.4.x + mdadm 3.3) and started 
> digging...
> 
> Since this is the first time, that a I face such a large array and such 
> an issue, I better follow the advice from the Linux-Raid-Wiki and 
> request for help.
> 
> As one can see in the attached log, the 'Events' count of 40 drives is 
> 4391 and 4385 for the 8 others. We have the same picture for the 
> 'State', 40 drives state 'clean' and 8 drives 'active'. So I tried 
> 'mdadm --assemble --force ...'.  This fixed the event count and faulty 
> flag on 4 of the 8 disks. But still the array can't be created.
> 
> Except one smart error (1 Currently unreadable (pending) sectors) do all 
> other drives pass the extended smart test. I know, this does not mean 
> that the drives are not damaged or broken.
> 
> Anyway, how should I process to get the array working again?
> 
You're the second person in the last month to run into this...  There
was a bug in mdadm that makes it fail with --assemble --force when there
are several out-of-date devices.

The fix was to clone the mdadm git tree, compile the latest, and run
that stand-alone binary to perform the forced assembly.  I haven't tried
to determine which released version has the fix.

Phil
