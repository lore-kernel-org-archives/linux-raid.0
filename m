From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: mdadm -D shows incorrect working devices ?
Date: Sun, 5 Jan 2003 21:10:11 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.51.0301052109430.31131@ddx.a2000.nu>
References: <Pine.LNX.4.50.0212172214130.25725-100000@ddx.a2000.nu>
 <Pine.LNX.4.50.0212182153120.4838-100000@ddx.a2000.nu>
 <Pine.LNX.4.50.0212221112050.24883-100000@ddx.a2000.nu>
 <Pine.LNX.4.51.0301021611450.11876@ddx.a2000.nu> <002701c2b320$4da3c8e0$6401a8c0@cfl.rr.com>
 <Pine.LNX.4.51.0301032202420.18601@ddx.a2000.nu> <021801c2b3fb$0c341be0$6401a8c0@cfl.rr.com>
 <Pine.LNX.4.51.0301050216270.23409@ddx.a2000.nu> <011f01c2b4d1$7a0e0960$6401a8c0@cfl.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <011f01c2b4d1$7a0e0960$6401a8c0@cfl.rr.com>
To: Mike Black <mblack@csi-inc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 5 Jan 2003, Mike Black wrote:

> One more idea -- try doing an "mdadm --zero-superblock" on all your devices before you build them.
> This looks to me like the info is being carried forward because of the "persistent" superblocks.
> I don't know how to fix this on a running array.

don't think i want to do this ?
(since i have data on this raid5)
