From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: Promise 378 tx2(plus) serial ata w/ 2.6.1
Date: Wed, 28 Jan 2004 17:04:42 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040128150442.GI8005@hvs.envisage.co.za>
References: <1075301763.18600.105.camel@wayde.rarcoa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1075301763.18600.105.camel@wayde.rarcoa.com>
To: Wayde Milas <wmilas@rarcoa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 28, 2004 at 08:56:03AM -0600, Wayde Milas wrote:
> Thought I'd try here before I went to the kernel mailing list.
> 
> I'm tying to get my promise 378 tx(plus2) chip thats built into my msi
> 865pe neo2 working. I'm aiming for a 4 drive sata raid 5 array, and I've
> got the 2 sata ports on the intel chip working flawlessly.

I'm using the MSI K8T Neo (AMD64) with the VIa & Promise 378 without hassles
on both the SATA controllers using a raid0 stripe on the drives connected
to the promise SATA. I'm using 2.6.0 since -test10 without hassles.
