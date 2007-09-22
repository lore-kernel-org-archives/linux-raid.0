From: Iustin Pop <iusty@k1024.org>
Subject: Re: Speaking of network disks (was: Re: syncing remote homes.)
Date: Sat, 22 Sep 2007 19:41:08 +0200
Message-ID: <20070922174108.GA28106@teal.hq.k1024.org>
References: <Pine.LNX.4.64.0709221022440.7723@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709221022440.7723@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Sep 22, 2007 at 10:28:44AM -0700, Mr. James W. Laferriere wrote:
> 	Hello Bill & all ,
>
> Bill Davidsen <davidsen@tmr.com> Sat, 22 Sep 2007 09:41:40 -0400 ,  wrote:
>> My only "advice" is to try and quantify the data volume and look at nbd 
>> vs. iSCSI to provide the mirror if you go that way.
>
> 	You mentioned nbd as a transport for disk to remote disk .
>
> 	My Question is have you OR anyone else tried using drbd(*) as a
> 	method to replicate disk data across networks ?

I have used it only in local networks, but it works very well. It's
much, much better than md + nbd, for example, because it was designed
with the network in mind - so it deals gracefully with transient network
errors and such.

And the current version (8.x) is also more flexible than the previous
versions. I'd recommed you give it a try.

regards,
iustin
