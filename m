From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Replacing Dead Disks in Hardware Array
Date: Tue, 4 Jan 2005 08:34:12 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501040832080.16453@lion.drogon.net>
References: <41D9E3B0.6080808@ruthless.ws>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41D9E3B0.6080808@ruthless.ws>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Thompson <mark@ruthless.ws>
Cc: Mailing List - Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 4 Jan 2005, Mark Thompson wrote:

> Hi there,
>
> While this isn't specific to linux, I've recently had a 160 gig 5400 RPM
> Maxtor drive die in my Hardware raid (3ware Escalade PATA Controller) as
> I am unable to find a suitable drive to replace it, would it be possible
> to repleace it with a 7200RPM Maxtor 160 gig drive?
>
> Model:
> Maxtor D540X-4G 5400 RPM
> 160 GB Ultra ATA/133 Hard Drive
>
> PS: I live in New Zealand where sourcing old/obscure drives can become
> very difficult so I'm looking at just upgrading to a newer disk.

As long as the total number of blocks are the same (or slightly more) you
shouldn't have a problem.

However, check the archives for comments on Maxtor disks (I've had one
fail personally), and you also might find that the 7200 RPM drive runs
slightly hotter than the 5400 RPM drive, so make sure the airflow &
cooling are good.

Gordon
