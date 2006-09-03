From: dean gaudet <dean@arctic.org>
Subject: Re: RAID-5 recovery
Date: Sun, 3 Sep 2006 15:32:27 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609031530010.12203@twinlark.arctic.org>
References: <200609031148.56910.clive@vacuumtube.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609031148.56910.clive@vacuumtube.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Clive Messer <clive@vacuumtube.org.uk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 3 Sep 2006, Clive Messer wrote:

> This leads me to a question. I understand from reading the linux-raid archives 
> that the current behaviour when rebuilding with a single badblock on another 
> disk is for that disk to also be kicked from the array.

that's not quite the current behaviour.  since 2.6.14 or .15 or so md will 
reconstruct bad blocks from other disks and try writing them.  it's only 
when this fails repeatedly that it knocks the disk out of the array.

-dean

-- 
VGER BF report: H 0.347442
