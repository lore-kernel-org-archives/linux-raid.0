From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: RE: Questions about VERY large software raid config
Date: Fri, 21 Feb 2003 12:39:20 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302211237240.8171-100000@router.windsormachine.com>
References: <8075D5C3061B9441944E137377645118012E66@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8075D5C3061B9441944E137377645118012E66@cinshrexc03.shermfin.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 21 Feb 2003, Rechenberg, Andrew wrote:

> Isn't it 2TB per RAID device (i.e. Linux block device) or 2TB in total?
>
>
> I have 28 36GB 15K drives and 28 18GB 15K drives.

Sorry, I got the impression you were making one device of 56/2 = 28
drives in raid0
It should be per raid device, yes.


