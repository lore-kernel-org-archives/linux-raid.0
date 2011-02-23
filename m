From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm ddf questions
Date: Wed, 23 Feb 2011 17:17:12 +1100
Message-ID: <20110223171712.09509f9e@notabene.brown>
References: <4D5FA5C4.8030803@gmail.com>
	<4D63688E.5030501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D63688E.5030501@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Feb 2011 08:41:02 +0100 Albert Pauw <albert.pauw@gmail.com> wrote:

> When I removed the correct disk, which can only be done from the container:
> 
> mdadm -r /dev/md127 /dev/sdb
> 
> the command mdadm -E /dev/md127 showed the 5 disks, the entry for sdb 
> didn't had a device but was still
> "active/Online" and sdd was marked Failed:

.....

> 
> So it looks like there are some errors in here.
> 

Indeed it does.  Thank you for putting some time in to testing and producing
an excellent problem report.
I have not put as much time into testing and polishing the DDF implementation
as I would have liked, partly because there doesn't really seem to be much
interest. 
But reports like this make it a whole lot more interesting.

I will try to look at this some time soon and let you know what I find in the
code - feel free to remind me if you haven't heard in a week.

Thanks,
NeilBrown

