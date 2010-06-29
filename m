From: Shaochun Wang <scwang@ios.ac.cn>
Subject: Re: RAID5 write hole?
Date: Tue, 29 Jun 2010 21:28:16 +0800
Message-ID: <20100629132816.GA1705@localhost>
References: <20100626143125.GA1010@localhost>
 <4C27290D.6000609@xs4all.nl>
 <20100627221613.0c34c812@notabene.brown>
 <20100629061634.GA20532@localhost>
 <alpine.DEB.1.10.1006290822470.8623@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1006290822470.8623@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 29, 2010 at 08:23:35AM +0200, Mikael Abrahamsson wrote:
> On Tue, 29 Jun 2010, Shaochun Wang wrote:
> 
> $ cat /proc/mdstat | grep bitmap
>        bitmap: 0/8 pages [0KB], 131072KB chunk
> 
> If you don't get any bitmap information in there, it's not enabled.
It seems that I do not have write-intent bitmap enabled. If
write-intent bitmap is useful, why is it not the default one?

-- 
Shaochun Wang <scwang@ios.ac.cn>

Jabber: fungusw@jabber.org
