From: NeilBrown <neilb@suse.de>
Subject: Re: User space RAID-6 access
Date: Tue, 1 Feb 2011 07:52:59 +1100
Message-ID: <20110201075259.4beaf501@notabene.brown>
References: <20110131202054.GA15712@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131202054.GA15712@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 21:20:55 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi all,
> 
> some times ago, I think was Neil, it was mentioned
> about the possibility to access consistently a RAID-6
> array from user space, in order to be able to perform
> some checks, like the notorius "which HDD has wrong data".
> 
> Is there any reference or documentation or source code
> which can be taken as example for such a case?
> 

Look in the mdadm source code, particularly at restripe.c

Also
   make test_stripe

make a program the the test suite uses for verify data correctness.

That should give you enough hints to get you started.

NeilBrown

