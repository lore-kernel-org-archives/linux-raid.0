From: Al Boldi <a1426z@gawab.com>
Subject: Re: Propose of enhancement of raid1 driver
Date: Sat, 28 Oct 2006 20:31:07 +0300
Message-ID: <200610282031.07893.a1426z@gawab.com>
References: <45347D6E.3000600@mieszczak.com.pl> <17718.61672.794099.425723@cse.unsw.edu.au> <ehin29$80g$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ehin29$80g$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> Neil Brown <neilb@suse.de> wrote:
> > Skipping over blocks within a track is no faster than reading blocks
> > in the track, so you would need to make sure that your chunk size is
>
> Not even "no faster" but probably even "slower".

Surely slower, on conventional hds anyway.

But what still isn't clear, why can't raid1 use something like the raid10 
offset=2 mode?


Thanks!

--
Al

