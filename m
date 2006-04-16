From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Sun, 16 Apr 2006 20:46:52 -0300
Message-ID: <17474.55148.614834.999648@fisica.ufpr.br>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	<17474.51121.178492.61143@cse.unsw.edu.au>
	<62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com>
	<17474.54168.331725.412456@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17474.54168.331725.412456@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown (neilb@suse.de) wrote on 17 April 2006 09:30:
 >The easiest thing to do when you get an error on a drive is to kick
 >the drive from the array, so that is what the code always did, and
 >still does in many cases.
 >It is arguable that for a read error on a degraded raid5, that may not
 >be the best thing to do, but I'm not completely convinced.

I don't see how it could be different. If the array is degraded and
one more disk fails there's no way to obtain the information, so the
md device just fails like a single disk.
