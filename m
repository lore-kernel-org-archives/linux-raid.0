From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Customize the error emails of  `mdadm --monitor`
Date: Wed, 6 Jun 2007 16:10:35 +0200
Message-ID: <20070606141035.GA9404@boogie.lpds.sztaki.hu>
References: <46619542.6010507@rabbit.us> <46669B20.6030706@rabbit.us> <20070606121121.GA23486@teal.hq.k1024.org> <4666A743.3050900@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4666A743.3050900@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 06, 2007 at 02:23:31PM +0200, Peter Rabbitson wrote:

> This would not work as arrays are assembled by the kernel at boot time, at 
> which point there is no udev or anything else for that matter other than 
> /dev/sdX. And I am pretty sure my OS (debian) does not support udev in 
> initrd as of yet.

But I think sending mails from the initrd isn't supported either, so if
you already hack the initrd, you can get the path information from
sysfs. udev is nothing magical, it just walks the sysfs tree and calls
some little helper programs when collecting the information for building
/dev/disk; you can do that yourself if you want.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
