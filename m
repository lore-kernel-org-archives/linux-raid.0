From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Intel SSD or other brands
Date: Fri, 30 Dec 2016 18:32:11 +0200
Message-ID: <20161230163210.GW28824@reaktio.net>
References: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
 <CAFx4rwT+j3mx3B_bj803Zs1kX=x-1w4Nwwsyb=a=NumFo8-Ufw@mail.gmail.com>
 <6199a648-eebe-687d-1a13-3f2dd954ae54@websitemanagers.com.au>
 <CAFx4rwRUnfCXgM66oa+-GYbtthVZvtHQkb2-J3XqUU9YXWF6sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFx4rwRUnfCXgM66oa+-GYbtthVZvtHQkb2-J3XqUU9YXWF6sA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

On Thu, Dec 29, 2016 at 05:24:16PM -0800, Doug Dumitru wrote:
> 
> My test is of a "managed" array with a "host side Flash Translation
> Layer".  This means that software is linearizing the writes before
> RAID-5 sees them.  This is how the major "storage appliance" vendors
> get really fast performance.  One vendor, running an earlier version
> of the software I am running here, was able to support 5000 ESXI VDI
> clients from a single 2U storage server (with a lot of FC cards).  The
> boot storm took about 3 minutes to settle.
>

Does this software happen to be opensource / publicly available ? 


Thanks,

-- Pasi
 
> Single drives are around 500 MB/sec which is 125K IOPS through our
> engine.  Eight drives are (8-1)x500=3500 MB/sec or 900K IOPS.  This is
> actually faster than FIO can generate a test pattern from a single
> job.  It is also faster than stock RAID-5 can linearly write without
> patches.
> 
> In terms of wear, lots of users are running very light write
> environments.  This is good as many configurations are > 50:1 write
> amp if you measure "end to end".  By end to end, I mean, how many
> flash writes happen when you create a small file inside of a file
> system.  This leads to "file system write amp" x "raid write amp" x
> "SSD write amp".  Some people don't like this approach as the file
> system is often "off limits" and a black box.  Then again, some file
> systems are better than others (for 10K sync creates, EXT4 and XFS are
> both about 4.4:1 whereas ZFS is a lot worse).  And with EXT4/XFS, you
> can mitigate some of this with an SSD or mapping layer that compresses
> blocks.
> 
> Doug Dumitru
> 

