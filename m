From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Problem with 5disk RAID5 array - two drives lost
Date: Sat, 22 Apr 2006 21:52:01 +0200
Message-ID: <62b0912f0604221252s7934dbf5qca6c0d8e8ae9498f@mail.gmail.com>
References: <A2F915E2-EC52-4EFE-86C2-547A71F8D788@writemem.com>
	 <62b0912f0604212054m40283fdbybdb6cd89e61dd153@mail.gmail.com>
	 <17482.34615.908339.197028@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17482.34615.908339.197028@fisica.ufpr.br>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho wrote:
> What you can also do is dd the disk to another one and try to rebuild
> the array with the new disk so that you won't get errors during the
> reconstruction.

Right, neat hack.

> Some people prefer to use ddrescue instead of dd; I've never tried it.

I can definitely recommend dd_rescue/dd-rescue/ddrescue.
Much better than dd for this kind of thing.

Very delicious.  Yummy yummy.
