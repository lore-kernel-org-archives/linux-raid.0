From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: Unable to eradicate previous version of device information, even
 with zero-superblock and dd
Date: Mon, 28 Jan 2008 13:18:48 -0600
Message-ID: <479E2A98.7010908@pobox.com>
References: <479DEF34.70306@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479DEF34.70306@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> QUESTIONS:
> 
> 1. If I create a device called /dev/md/all, should I expect that mdadm 
> will create a device called /dev/md/127, and that mdadm --detail --scan 
> will report it as /dev/md127 or something similar?

That's still happening. However:

> 2. How can I completely eradicate all traces of previous work, given 
> that zero-superblock and dd on the drives that make up the array doesn't 
> seem to erase previous information?

Answer:

In order for the md drives to be started on a reboot, upgrade-initramfs 
    places information about the current configuration into boot 
configuration.

In order to eradicate everything, stop all arrays, comment out any ARRAY 
lines in mdadm.conf, remove all md device files, and then issue

update-initramfs

This cleans out the information that's hidden inside the /boot area. On 
the next reboot, no extraneous md files are present. It's then possible 
to issue an mdadm --create /dev/md/all that will create the appropriate 
md devices automatically with proper major and minor device numbers.

To get the md device started correctly at init time, I seem to require 
the use of update-initramfs. I will investigate further when I've got 
some time...


-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "The odds are good, but the goods are odd."
    	     -- Alaskan women, on the high ratio of men to women in Alaska
