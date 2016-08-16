From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Can't mount Old RHEL 6 Raid with new install of CentOS 7, now
 can't mount with original RHEL 6
Date: Tue, 16 Aug 2016 13:09:12 -0600
Message-ID: <CAJCQCtQJrrtqvsEZa4wV2guMUfS-kmUF4Gg52nTHG2pM-a0A=g@mail.gmail.com>
References: <42cee2e2d85a5b0e39efc34117e597a2@celticblues.com>
 <CAJCQCtQfBjhKh2Fu+W76JyXODFJJ9Qxjbyn7KK0i3ALs1xREgQ@mail.gmail.com>
 <57d23adc6db12d6a365dd2c6f50d4bf5@celticblues.com> <CAJCQCtSHffOMy7xvNyR2KshFfiwL3e4Jrt2BPY90CMrRY5nRyQ@mail.gmail.com>
 <fd2b2aab-a0c1-4e20-89e2-f859b488e4e9@Spark> <CAJCQCtTAjg5bgboMjMyu0gMx57J0n6Po1uppsEoFvGAYCwV6xA@mail.gmail.com>
 <02fd3a31-b107-464d-aa58-2ccd5660d974@Spark>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02fd3a31-b107-464d-aa58-2ccd5660d974@Spark>
Sender: linux-raid-owner@vger.kernel.org
To: John Dawson <linux@celticblues.com>
Cc: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 16, 2016 at 12:59 PM,  <linux@celticblues.com> wrote:
> I tried to assemble the raid array again. If that doesn't explain it, then I
> don't know.


Why would trying to assemble the raid change anything? The array is
assembling correctly per the metadata on those two drives. That
there's no ext4 signature on that array, the date of creation of the
array is 10 days ago, all suggests that the original array used
metadata version other than 1.2, putting the ext4 superblock in the
location where 10 days ago mdadm --create obliterated that ext4
superblock with an mdadm 1.2 superblock.

There are a lot of "fix me" guides out there that suggest doing mdadm
--create and it's 99% of the time really horrifically bad advice that
causes data loss that looks awfully lot like what's going on here.


>The two drives that make up the array haven't been
> touched/modified.

Obviously that's not true.

The only possible chance to recover this is if you have an exact
sequence of events modifying the drive, so that they can maybe be
reversed. Without that, any change will do more damage and decrease
the chance of recovery. But seeing as this is a raid0 I suspect you
have a complete backup of the drive anyway so you're probably better
off just starting over with it.



-- 
Chris Murphy
