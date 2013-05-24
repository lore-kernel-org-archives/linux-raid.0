From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Attempt to change raid1 to raid0 results in division error in
 kernel
Date: Thu, 23 May 2013 20:40:13 -0500
Message-ID: <519EC4FD.1090800@hardwarefreak.com>
References: <20130523104400.GA827@gbl-macbook>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130523104400.GA827@gbl-macbook>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Goliasz <r.goliasz@digital-science.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/23/2013 5:44 AM, Robert Goliasz wrote:
> Hi,
> 
> When attempting to change raid level from 1 to 0 

I don't even know if this is possible.

> (I was doing some testing
> trying to convert a raid1 array to a raid10 one), I got a division error.
...
>   gbl-macbook# mdadm --grow /dev/md0 -l 0

If it is possible, this command line won't work because you didn't
specify a chunk size for the RAID0 stripe.  Every striped array type
requires a chunk size.

>   zsh: segmentation fault  mdadm --grow /dev/md0 -l 0
>   gbl-macbook# 
...

> Afterwards, my mounted filesystem (/dev/md0) disappeared (it's no longer
> mounted), and all operations related to software raid seem to fail:

Well of course.  Experimenting with mdadm without knowing what you're
doing will often result in lost/corrupted arrays and other forms of damage.

At this point you should simply start a new thread and ask:

"How do I convert a RAID1 array to RAID0?"

or

"How do I convert a RAID1 array to RAID10?"

instead of working backwards from your mistakes here.

-- 
Stan

