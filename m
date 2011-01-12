From: David Flynn <davidf@rd.bbc.co.uk>
Subject: Re: md raid5 blocked in get_active_stripe after disk failure
Date: Wed, 12 Jan 2011 14:06:32 +0000
Message-ID: <20110112140632.GB6275@rd.bbc.co.uk>
References: <20110112130420.GA6275@rd.bbc.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110112130420.GA6275@rd.bbc.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* David Flynn (davidf@rd.bbc.co.uk) wrote:
> I have a fileserver that mounts an md raid5 array with 20 active disks,
> holding an xfs filesystem which is then exported via nfs. (system is
> a twin-quadcore intel, 64bit)

I ought to mention, this is running 2.6.35.8

..david
