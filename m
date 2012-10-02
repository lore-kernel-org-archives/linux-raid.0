From: Mark Munoz <mark.munoz@rightthisminute.com>
Subject: Re: MD RAID Bug 7/15/12
Date: Tue, 2 Oct 2012 15:53:34 -0700
Message-ID: <2599ECDD-7B9E-4272-BAFC-E4A04880D12E@rightthisminute.com>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com> <20121001130242.745b7ca3@notabene.brown> <42BA87F6-C5A3-4321-A4C7-0DCF0A9DF79D@rightthisminute.com> <20121002114920.1029bed7@notabene.brown> <0B674309-5CBC-4C36-983F-AB75D9C2BDDB@rightthisminute.com> <20121002150740.717a9448@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121002150740.717a9448@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

I just wanted to send you a HUGE thank you.  We got back all of our data and are very pleased!  Do you guys have some sort of donation fund or something that we can send something to your team to show our appreciation?

Mark

On Oct 1, 2012, at 10:07 PM, NeilBrown <neilb@suse.de> wrote:

> On Mon, 1 Oct 2012 19:33:50 -0700 Mark Munoz <mark.munoz@rightthisminute.com>
> wrote:
> 
> 
>> So I am now thinking that during my shutdown this weekend the device /dev/md0 as part of the array /dev/md2 was affected by the bug as well as 18 of the 19 devices contained inside of /devm/md1
> 
> Yes, I agree, so:
> 
>>>> 
>>>> sudo mdadm --create --assume-clean /dev/md2 --level=0 --chunk=64 --metadata=1.2 --raid-devices=2 /dev/md0 /dev/md1
> 
> This is the correct thing to do.
> 
> NeilBrown
> 
> 

