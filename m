From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: Reproducable OOPS with MD RAID-5 on 2.6.0-test11
Date: Mon, 1 Dec 2003 20:15:13 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031202041513.GN1566@mis-mike-wstn.matchmail.com>
References: <3FCB4AFB.3090700@backtobasicsmgmt.com> <20031201141144.GD12211@suse.de> <3FCB4CFA.4020302@backtobasicsmgmt.com> <20031201155143.GF12211@suse.de> <3FCC0EE0.9010207@backtobasicsmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FCC0EE0.9010207@backtobasicsmgmt.com>
To: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Cc: Jens Axboe <axboe@suse.de>, LKML <linux-kernel@vger.kernel.org>, Linux-raid maillist <linux-raid@vger.kernel.org>, linux-lvm@sistina.com
List-Id: linux-raid.ids

On Mon, Dec 01, 2003 at 09:02:40PM -0700, Kevin P. Fleming wrote:
> Tested with mem=800m, problem still occurs. Additional test was done 
> without device-mapper in place, though, and I could not reproduce the 
> problem! I copied > 500MB of stuff to the XFS filesystem created using 
> the entire /dev/md/0 device without a single unusual message. I then 
> unmounted the filesystem and used pvcreate/vgcreate/lvcreate to make a 
> 3G volume on the array, made an XFS filesystem on it, mounted it, and 
> tried copying data over. The oops message came back.

Can you try with DM on regular disk tm, instead of sw raid?
