From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Opal 2.0 SEDs on linux, was: Very long raid5 init/rebuild times
Date: Wed, 22 Jan 2014 12:38:42 -0700
Message-ID: <6E40E2A4-66D8-4218-8846-4A6051F14AAC@colorremedies.com>
References: <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52DF7976.6070808@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 22, 2014, at 12:55 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
> You are not CPU bound, nor hardware bandwidth bound.  You are latency
> bound, just like every dmcrypt user.  dmcrypt adds a non trivial amount
> of latency to every IO.  Latency with serial IO equals low throughput.

A self-encrypting drive (a drive that always & only writes ciphertext to the platters) I'd expect totally eliminates this. It's difficult finding information whether and how these drives are configurable purely for data drives (non-bootable) which ought to be easier to implement than the boot use case.

For booting, it appears necessary to have computer firmware that explicitly supports the TCG OPAL spec: an EFI application might be sufficient for unlocking the drive(s) at boot time, but I'm not certain about that. It seems necessary for hibernate support that firmware and kernel support is required.

Chris Murphy

