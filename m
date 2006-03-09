From: dean gaudet <dean@arctic.org>
Subject: Re: Auto-assembling arrays using mdadm
Date: Thu, 9 Mar 2006 09:41:19 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603090939410.32502@twinlark.arctic.org>
References: <20060309085406.54370.qmail@web35312.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060309085406.54370.qmail@web35312.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sean Puttergill <puttergi@yahoo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 9 Mar 2006, Sean Puttergill wrote:

> Hi.
> 
> I am looking to script auto-assembly of all arrays
> detected on an arbitrary set of drives using mdadm.
> 
> The way I am thinking of doing this is as follows:
> 
> mdadm.conf =
> 
> DEVICE /dev/sd*

i prefer to use "DEVICE partitions"

> 1. Use "mdadm -E" on each drive in turn to get the
> UUID for the array to which it belongs and assemble a
> list of unique UUIDs.
> 
> 2. Run "mdadm -A --uuid=<UUID> --auto=md --scan" for
> each unique UUID.
> 
> 
> My question is, is it currently possible for me to get
> mdadm to do this automatically?

the man page has an example... it's just:

	mdadm --assemble --scan

-dean
