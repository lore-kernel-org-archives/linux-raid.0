From: Andy Smith <andy@strugglers.net>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Sun, 24 Aug 2014 13:19:22 +0000
Message-ID: <20140824131922.GF11855@bitfolk.com>
References: <20140823163110.GE11855@bitfolk.com>
 <20140824130939.461501b4@notabene.brown>
 <E78FE8BDBAD07C43A60163E7D1716EEC0183A72805@PROSIS-W2K8-1.prosis.local>
 <20140824164507.4954df45@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140824164507.4954df45@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Aug 24, 2014 at 04:45:07PM +1000, NeilBrown wrote:
> > >      Array Size : 471859200 (450.00 GiB 483.18 GB)
> > >   Used Dev Size : 309363520 (295.03 GiB 316.79 GB)
> 
> This is a near=2 6 drive RAID10, so Array Size should be 3 times Used Dev
> Size.
> The fact that it isn't shows that he has already explicitly set the
> --array-size to something appropriate.   I'm sure he reduced the size of the
> filesystem first as the man page says:

Yup, it's an LVM PV so I did pvresize and mdadm --array-size first
to some safe lower value, before I realised that mdadm would have
told me the exact --array-size I needed anyway.

I should have mentioned that to reduce confusion, but it didn't
seem pertinent to where I got stuck.

Cheers,
Andy
