From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Unable to reactivate a RAID10 mdadm device
Date: Tue, 12 Feb 2013 16:28:04 -0500
Message-ID: <CAKHEz2ZDznrROkXRF6Mzmb4vVwkfG1ab+GPCwaAqML3i89fsuw@mail.gmail.com>
References: <CAHhM8gBza3j-3qE3dRkZy14_cO-6EjOjW-zU8mtHVxhy6EWrtw@mail.gmail.com>
	<CAKHEz2bCyaqTa7dH-OFNR8_xs9O=XUD918vpVb+kL-gfOSq7gA@mail.gmail.com>
	<CAHhM8gA4JkC0ORbg2NhdxmQA3Ufag1fy48SPU-jE+MsjD9SRgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHhM8gA4JkC0ORbg2NhdxmQA3Ufag1fy48SPU-jE+MsjD9SRgQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arun Khan <knura9@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 12, 2013 at 6:25 AM, Arun Khan <knura9@gmail.com> wrote:
> I used 'watch cat /proc/mdstat' to watch the rebuild progress and the
> progress bar showed completion (100%) mark.
> When I broke out of this session and thereafter did 'cat /proc/mdstat'
>  I noticed that not only was /dev/sdb1 not added but /dev/sdc1 was
> also not part of the array anymore.   With two failed devices,
> /dev/md0 was still working mounted on /mnt/md0.
>

have you tried adding the --force option to assemble? I would leave
out sdb since its an empty drive.

If that brings it online you can try a read-only fsck with -n to check
the consistency of your data.


-- 
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
