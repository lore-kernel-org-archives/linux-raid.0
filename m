From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: raid6 resync blocks the entire system
Date: Tue, 20 Nov 2007 00:55:52 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711200045130.4836@coffee.psychology.mcmaster.ca>
References: <fhq60j$an9$1@ger.gmane.org> <18240.42344.102986.988879@base.ty.sabi.co.UK>
 <20071118221819.GA26053@lanczos.q-leap.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071118221819.GA26053@lanczos.q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I know this is a high end configuration, but no latency critical component
> is at any limit, 4 CPUs are idling, PCI-X busses are
> far away from being saturated.

yes, but what about memory?  I speculate that this is an Intel-based 
system that is relatively memory-starved.
