From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 3ware bad write speed.
Date: Wed, 26 Mar 2003 10:55:16 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303261053470.2059-100000@chaos.egr.duke.edu>
References: <Pine.LNX.4.53.0303260139360.21075@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0303260139360.21075@ddx.a2000.nu>
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 26 Mar 2003 at 1:40am, Stephan van Hienen wrote

> On Mon, 24 Mar 2003, Joshua Baker-LePain wrote:
> 
> > 2) Make sure that your kernel supports HIGHIO.  I don't know if that
> > enterprise kernel does (do you need to run it?), but it makes a *big*
> > difference.  The latest 3ware drivers support HIGHIO, but the kernel needs
> > to as well.
> 
> what is this HIGHIO (patch?) ?

From Documentation/Configure.help:

HIGHMEM I/O support
CONFIG_HIGHIO
  If you want to be able to do I/O to high memory pages, say Y.
  Otherwise low memory pages are used as bounce buffers causing a
  degrade in performance.

It's in mainline as of 2.4.20, and I know that RH has included it for a 
while.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University

