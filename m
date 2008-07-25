From: Arthur Jones <ajones@riverbed.com>
Subject: Re: raid10 failing to fail...
Date: Fri, 25 Jul 2008 12:05:56 -0700
Message-ID: <20080725190556.GA19304@ajones-laptop.nbttech.com>
References: <20080721190018.GA18246@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080721190018.GA18246@ajones-laptop.nbttech.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 21, 2008 at 12:00:18PM -0700, Arthur Jones wrote:
> Hi All,  I have a raid10 array md0 which, when I
> fail all reads on the first underlying block device
> (/dev/sda5), reads from the array hang forever.

This issue is now fixed with the patch I just
posted...

Arthur

