From: David Rees <dbr@greenhydrant.com>
Subject: Re: IDE bus rescan
Date: Tue, 4 Jun 2002 23:05:50 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020604230550.A30029@greenhydrant.com>
References: <5.1.0.14.2.20020604123917.06a1ac50@mail.harddata.com> <5.1.0.14.2.20020604171615.03d9ab90@mail.harddata.com> <3CFD4BA8.3010409@fl.priv.at> <5.1.0.14.2.20020604174357.06a2ba50@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5.1.0.14.2.20020604174357.06a2ba50@mail.harddata.com>; from maurice@harddata.com on Tue, Jun 04, 2002 at 11:37:30PM -0600
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 04, 2002 at 11:37:30PM -0600, Maurice Hilarius wrote:
> With regards to your message at 05:22 PM 6/4/02, Friedrich Lobenstock. 
> Where you stated:
> >Maurice Hilarius wrote:
> >>>Are you using the 3Ware Diskmanager Daemon and its webinterface or not?
> >>>It seems not.
> >>As I understand it that is only useful if we use the 3Ware BIOS RAID.
> >>In this case we are interested in doing this with software RAID
> >>So how would we make it rescan with this??
> >
> >Then why on earth did you buy a 3Ware Controller if you are using it as a
> >normal ide controller?
> 
> A few good reasons:
> Performance using software RAID is about twice as fast
> When using software RAID it is not fussy if all disks are identical or not.
> The 3Ware makes a really good disk interface, is fast, and uses little CPU.

If you use 3DM, you should be able to do it this way:

1. Navigate to the Configure Display. 
2. Click on the check box of the failed drive. 
3. Click button Remove Drive. 
4. Physically remove the failed drive and replace it with a new drive. 
5. Click on the check box of the new drive. 
6. Click button Add Drive. 

I haven't actually tried it myself, but this should work.

-Dave
