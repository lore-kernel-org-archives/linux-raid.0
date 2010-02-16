From: CaT <cat@zip.com.au>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 14:40:06 +1100
Message-ID: <20100216034005.GE4143@zip.com.au>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 11, 2010 at 05:52:41PM -0800, Michael Evans wrote:
> You need the superblock at the end of the partition:  If you read the
> manual that is clearly either version 0.90 OR 1.0 (NOT 1.1 and also

For lilo, at least, this is not so:

http://www.sfr-fresh.com/linux/misc/lilo-22.8.src.tar.gz:a/lilo-22.8/raid.c

Line 145:

if (ioctl(md_fd,RAID_VERSION,&md_version_info) < 0)

Line 155:

if (ioctl(md_fd,GET_ARRAY_INFO,&md_array_info) < 0)

Lines 160-168:

if ((md_array_info.major_version != md_version_info.major) &&
	(md_array_info.minor_version != md_version_info.minor)) {
    die("Inconsistent Raid version information on %s   (RV=%d.%d GAI=%d.%d)",
        boot,
              (int)md_version_info.major,
              (int)md_version_info.minor,
              (int)md_array_info.major_version,
              (int)md_array_info.minor_version);
    }

It's 0.90 or nothing as md_version_info gives 0.90 due to:

/linux/drivers/md/md.c:
Line 4599:

        ver.major = MD_MAJOR_VERSION;
        ver.minor = MD_MINOR_VERSION;

linux/include/linux/raid/md_u.h:
Line 23:

#define MD_MAJOR_VERSION                0
#define MD_MINOR_VERSION                90

I got bitten by this as I was testing different raid superblocks on a new
setup. Wound up hand-making my own initramfs, which was a pain (right pain
to debug). Would prefer not to have one tbh.

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
