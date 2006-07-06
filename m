From: "John Stoffel" <john@stoffel.org>
Subject: Re: second controller: what will my discs be called, and does it matter?
Date: Thu, 6 Jul 2006 18:05:17 -0400
Message-ID: <17581.35101.128252.9505@stoffel.org>
References: <200607062012.14684.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200607062012.14684.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Dexter> Currently I have 4 discs on a 4 channel sata controller which
Dexter> does its job quite well for 20 bucks.  Now, if I wanted to
Dexter> grow the array I'd probably go for another one of these.

So, which SATA controller are you using?  I'm thinking my next box
will go SATA, but I'm still deciding....

Dexter> How can I tell if the discs on the new controller will become
Dexter> sd[e-h] or if they'll be the new a-d and push the existing
Dexter> ones back?

Dexter> Next question: assembling by UUID, does that matter at all?
Dexter> (And while talking UUID - can I safely migrate to a
Dexter> udev-kernel? Someone on this list recently ran into trouble
Dexter> because of such an issue.)

I'm using udev and it's not a problem, but I admit I'm also
auto-assembling my arrays using the kernel detection stuff.  All I
have in my mdadm.conf file is 

    MAILADDR john
    PARTITIONS

and it just works for me.  But using the UUID is the way to go.

Though I admit my system may not be setup like you think.  I have a
pair of 120gb drives which are mirrored.  On top of them I have LVM
configured and a pair of partitions setup, so I can grow/move/shrink
them at some point.  Hasn't happened too often yet.  

So I'm not using ext3 -> MD -> disks, I'm adding in the LVM layer.

John
