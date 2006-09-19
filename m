From: Gaspar Bakos <gbakos@cfa.harvard.edu>
Subject: Re: RAID-5 making big partition fails
Date: Tue, 19 Sep 2006 17:37:31 -0400 (EDT)
Message-ID: <Pine.SOL.4.58.0609191737040.24136@titan.cfa.harvard.edu>
References: <Pine.SOL.4.58.0609191633020.24136@titan.cfa.harvard.edu>
 <Pine.LNX.4.62.0609191641200.29261@chaos.egr.duke.edu>
Reply-To: gbakos@cfa.harvard.edu
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0609191641200.29261@chaos.egr.duke.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: linux-raid@vger.kernel.org, fedora-list <fedora-list@redhat.com>
List-Id: linux-raid.ids

> In parted, you need to 'mklabel gpt'.  Standard msdos disklabels don't
> handle devices >2TiB.

Indeed, this solved the problem.
Thanks a lot!

Gaspar
