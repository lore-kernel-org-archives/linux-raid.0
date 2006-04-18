From: Nathanial Byrnes <nate@qabal.org>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Tue, 18 Apr 2006 19:39:38 -0400
Message-ID: <1145403579.15773.1.camel@nemo.qabal.org>
References: <1145106091.18173.18.camel@nemo.qabal.org>
	 <44456474.9040201@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44456474.9040201@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, I did not have the funding nor approval to purchase more hardware
when I set it up (read wife). Once it was working... the rest is
history.

On Tue, 2006-04-18 at 16:13 -0600, Maurice Hilarius wrote:
> Nathanial Byrnes wrote:
> > Hi All,
> > 	Recently I lost a disk in my raid5 SW array. It seems that it took a
> > second disk with it. The other disk appears to still be funtional (from
> > an fdisk perspective...). I am trying to get the array to work in
> > degraded mode via failed-disk in raidtab, but am always getting the
> > following error:
> >
> >   
> Let me guess:
> IDE disks, in pairs.
> Jumpered as Master and Salve.
> 
> Right?
> 
> 
> 
> 
> 

