From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Thu, 30 Mar 2006 10:59:10 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0603301057230.4271@chaos.egr.duke.edu>
References: <442BFB2B.6090903@stams.strath.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442BFB2B.6090903@stams.strath.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Thurlbeck <ian@stams.strath.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 30 Mar 2006 at 4:37pm, Ian Thurlbeck wrote

> I have 4x500GB Maxtor SATA drives and I want to attach
> these to a 4-port SATA PCI card and RAID5 them using "md"
>
> Could anybody recommend a card that will have out of
> box support on a Fedora system ?

3ware.  Period.  If you're going to use md, get the 8506-4 series rather 
than either of the 9xxx series cards.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
