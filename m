From: "John P. Looney" <valen@tuatha.org>
Subject: Re: Problems with RAID1 on cobalt raq3
Date: Thu, 22 Aug 2002 16:25:45 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020822152545.GJ3670@jinny.ie>
References: <200208172056.g7HKuHm05754@raq.iceblink.org> <1029624922.14769.119.camel@atherton> <20020819140815.GY26818@jinny.ie>
Reply-To: valen@tuatha.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020819140815.GY26818@jinny.ie>
To: linux-raid@vger.kernel.org
Cc: ilug@linux.ie
List-Id: linux-raid.ids

On Mon, Aug 19, 2002 at 03:08:16PM +0100, John P. Looney mentioned:
>  This is likely because to get it to boot, like the cobalt, I'm actually
> passing root=/dev/hda5 to the kernel, not /dev/md0. 

 Just to solve this...the reason I was booting the box with
root=/dev/hda5, not /dev/md0 was because /dev/md0 wasn't booting - it
would barf with 'can't find init'.

 It turns out that this is because I was populating md0 with tar. Which
seems to have 'issues' with crosslinked files - for instance, it was
trying to make a hard link of glibc.so to hda - and failing. It was only
as I did it again with a friend present, that he spotted the errors, and
queried them. We noticed that the hard linked files just didn't exist on
the new rootfs.

 When we duplicated the filesystems with dump instead of tar, it worked
fine, I was able to tell lilo to use root=/dev/md0 and everything worked.

 Woohoo.

Kate

