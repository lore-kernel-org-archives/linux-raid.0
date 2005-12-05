From: Neil Brown <neilb@suse.de>
Subject: Re: need help with raid6 recovery
Date: Mon, 5 Dec 2005 14:00:09 +1100
Message-ID: <17299.44345.986538.39600@cse.unsw.edu.au>
References: <200512021517.jB2FH9Ja010788@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Burgess on Friday December 2
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 2, aab@cichlid.com wrote:
> 
> OK! Now I can fsck -n and see how bad things are.

Hmmm. sounds like you had fun!!! :-)

> 
> A feature request would be for a way to force mdadm to use a device in a
> certain slot regardless of what the superblock says.

The recommended approach would be to recreate the array, making sure
you put everything in the right place.

NeilBrown
