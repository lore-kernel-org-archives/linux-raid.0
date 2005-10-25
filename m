From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Flappy hotswap disks?
Date: Tue, 25 Oct 2005 12:06:18 +0200
Message-ID: <62b0912f0510250306s29554e02x89e4fad97027d347@mail.gmail.com>
References: <62b0912f0510250137n6ba372c5x312174d908247437@mail.gmail.com>
	 <djktsk$72u$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <djktsk$72u$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> Molle Bestefich wrote:
> > Eg. will it increase the event counters on the other disks /even/ when
> > no reboot or stop-start has been performed, so that when the flappy
>
> Event counters are increased immediately when an event occurs.
> A device failure is an event as well as start and stop of a RAID are.

Ok.  Thanks!
Hope it's race-free and all :-).
