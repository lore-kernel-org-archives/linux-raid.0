From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 21 Jan 2014 11:42:10 -0700
Message-ID: <7464A4EA-3A1C-4C1D-88C4-C9D1F1AD44C9@colorremedies.com>
References: <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121163755.GG10140@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Mailing List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 21, 2014, at 9:37 AM, Marc MERLIN <marc@merlins.org> wrote:

> I should have said that this is seemingly a stupid question since obviously
> if you encrypt each drive separately, you're going through the encryption
> layer 5 times during rebuilds instead of just once.

It wasn't a stupid question, but I think you've succeeded in confusing yourself into thinking more work is happening by encrypting the drives rather than the logical md device.

> However in my case, I'm not CPU-bound, so that didn't seem to be an issue
> and I was more curious to know if the dmcrypt and dmraid5 layers stacked the
> same regardless of which one was on top and which one at the bottom.

md raid isn't dmraid. I'm actually not sure where the dmraid work is at. I'm under the impression most of that work is happening within LVM2 - they now have their own raid 0,1,10,5,6 implementation. My understanding is it uses md kernel code, but uses lvm tools to create and monitor, rather than mdadm.

Chris Murphy

