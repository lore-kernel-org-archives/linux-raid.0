From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: proactive-raid-disk-replacement
Date: Thu, 21 Sep 2006 12:28:42 -0400
Message-ID: <4512BDBA.8060300@tmr.com>
References: <200609161748.k8GHm4D02573@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609161748.k8GHm4D02573@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Tuomas Leikola' <tuomas.leikola@gmail.com>, 'Bodo Thiesen' <bothie@gmx.de>, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Guy wrote:

>} -----Original Message-----
>} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>} owner@vger.kernel.org] On Behalf Of Bill Davidsen
>} Sent: Saturday, September 16, 2006 10:29 AM
>} To: Tuomas Leikola
>} Cc: Bodo Thiesen; Linux RAID
>} Subject: Re: proactive-raid-disk-replacement
>} 
>} Tuomas Leikola wrote:
>} 
>} > On 9/10/06, Bodo Thiesen <bothie@gmx.de> wrote:
>} >
>} >> So, we need a way, to feedback the redundancy from the raid5 to the
>} >> raid1.
>} >
>} > <snip long explanation>
>} >
>} > Sounds awfully complicated to me. Perhaps this is how it internally
>} > works, but my 2 cents go to the option to gracefully remove a device
>} > (migrating to a spare without losing redundancy) in the kernel (or
>} > mdadm).
>} >
>} > I'm thinking
>} >
>} > mdadm /dev/raid-device -a /dev/new-disk
>} > mdadm /dev/raid-device --graceful-remove /dev/failing-disk
>} >
>} > also hopefully a path to do this instead of kicking (multiple) disks
>} > when bad blocks occur.
>} 
>} 
>} Actually, an internal implementation is really needed if this is to be
>} generally useful to a non-guru. And it has other possible uses, as well.
>} if there were just a --migrate command:
>}   mdadm --migrate /dev/md0 /dev/sda /dev/sdf
>} as an example for discussion, the whole process of not only moving the
>} data, but getting recovered information from the RAID array could be
>} done by software which does the right thing, creating superblocks, copy
>} UUID, etc. And as a last step it could invalidate the superblock on the
>} failing drive (so reboots would work right) and leave the array running
>} on the new drive.
>} 
>} But wait, there's more! Assume that I want to upgrade from a set of
>} 250GB drives to 400GB drives. Using this feature I could replace a drive
>} at a time, then --grow the array. The process for doing that is complex
>} currently, and many manual steps invite errors.
>
>I like the migrate option or whatever you want to call it.  However, if the
>disk is failing I would want to avoid reading from the failing disk and
>reconstruct the data from the other disks.  Only reading from the failing
>disk if you find a bad block on another disk.  This would put less strain on
>the failing disk possibly allowing it to last long enough to finish the
>migrate.  Your data would remain redundant throughout the process.
>  
>
This is one of those "maybe" things, the data move would take longer, 
increasing the chance of a total fail... etc. Someone else might speak 
to this, I generally find that the non-total failures usually result in 
writing bad sectors but reading not causing problems. Note _usually_. In 
either case, during the migrate you wouldn't want to write to the 
failing drive, so it would gradually fall out of currency in any case.

>However if I am upgrading to larger disks it would be best to read from the
>disk being replaced.  You could even migrate many disks at the same time.
>Your data would remain redundant throughout the process.
>
Many at a time supposes room for more new drives, and makes the code 
seem a lot more complex. I would hope this doesn't happen often enough 
to make efficiency important.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

