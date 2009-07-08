From: "NeilBrown" <neilb@suse.de>
Subject: RE: Question on RAID-5 using ADMA
Date: Thu, 9 Jul 2009 09:28:11 +1000 (EST)
Message-ID: <8ba75cd82b7938995077e9e157f5b93f.squirrel@neil.brown.name>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>
    <C804A8D3A7CE4E9B8B6CE8DFD11019B9@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C804A8D3A7CE4E9B8B6CE8DFD11019B9@m5>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'Tirumala Reddy Marri' <tmarri@amcc.com>, linux-raid@vger.kernel.org, 'Dan Williams' <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Thu, July 9, 2009 9:11 am, Guy Watkins wrote:
> I think you are doing --assume-clean wrong.
>
> Anyway, if you are bypassing the parity build with --assume-clean then how
> can you expect it to work with a failed disk?

That was my first thought too, but it doesn't actually follow.

With only 3 devices, every write will construct new correct parity, so
every block that was actually written will read back with the correct
data after a device failure.

There must be something going wrong in the xor calculations.


NeilBrown

