From: Konstantin Olchanski <olchansk@sam.triumf.ca>
Subject: Re: Good news / bad news - The joys of RAID
Date: Thu, 2 Dec 2004 21:40:18 -0800
Message-ID: <20041203054018.GC23350@sam.triumf.ca>
References: <200412030416.iB34Go913239@www.watkins-home.com> <41AFF87D.8080102@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41AFF87D.8080102@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 03, 2004 at 06:24:13PM +1300, Richard Scobie wrote:
> >If the problem was a firmware issue, why didn't IBM release a firmware
> >update?
> 
> I believe they did. I recall downloading something similar to this:
> http://support.dell.com/support/downloads/format.aspx?releaseid=r37239&c=us&l=en&s=biz&cs=555

The updated IBM firmware helped. Before, every power outage would
produce disks with unreadable sectors. Now, all our IBM disks have
the "new" firmware and they hardly ever develop unreadable sectors.

This makes me suspect that there are *two* unrelated problems:
1) the "scribble at power down" problem, fixed by the firmware update;
2) the "overheated disks lose data due to platter thermal expansion" problem,
   probably unfixable, other than by keeping the disks cool.

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
