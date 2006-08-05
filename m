From: David Greaves <david@dgreaves.com>
Subject: Re: raid5/lvm setup questions
Date: Sat, 05 Aug 2006 18:31:37 +0100
Message-ID: <44D4D5F9.9080201@dgreaves.com>
References: <20060805165358.GA29177@cm.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060805165358.GA29177@cm.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Shane <shane@cm.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shane wrote:
> Hello all,
> 
> I'm building a new server which will use a number of disks
> and am not sure of the best way to go about the setup. 
> There will be 4 320gb SATA drives installed at first.  I'm
> just wondering how to set the system up for upgradability. 
> I'll be using raid5 but not sure whether to use lvm over
> the raid array.
> 
> By upgradability, I'd like to do several things.  Adding
> another drive of the same size to the array.  I understand
> reshape can be used here to expand the underlying block
> device.
Yes, it can.

  If the block device is the pv of an lvm array,
> would that also automatically expand in which I would
> create additional lvs in the new space.  If this isn't
> automatic, are there ways to do it manually?
Not automatic AFAIK - but doable.

> What about replacing all four drives with larger units. 
> Say going from 300gbx4 to 500gbx4.  Can one replace them
> one at a time, going through fail/rebuild as appropriate
> and then expand the array into the unused space
Yes.

 or would
> one have to reinstall at that point.
No


None of the requirements above drive you to layering lvm over the top.

That's not to say don't do it - but you certainly don't *need* to do it.

Pros:
* allows snapshots (for consistent backups)
* allows various lvm block movements etc...
* Can later grow vg to use discrete additional block devices without raid5 grow
limitations (eg same-ish size disks etc)

Cons:
* extra complexity -> risk of bugs/admin errors...
* performance impact

As an example of the cons: I've just set up lvm2 over my raid5 and whilst
testing snapshots, the first thing that happened was a kernel BUG and an oops...

David
