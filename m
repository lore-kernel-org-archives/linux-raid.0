From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Multiple disk failure - recover?
Date: Wed, 10 Jul 2002 23:36:03 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15660.14403.330548.476141@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.30.0207101505480.25329-100000@duplo.agenda.si>
	<02e301c22814$27779300$f6de11cc@black>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Black on Wednesday July 10
To: Mike Black <mblack@csi-inc.com>
Cc: Danilo Godec <danci@agenda.si>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 10, mblack@csi-inc.com wrote:
> You don't say why two disks were kicked or when it happend so sdc may be out-of-whack a bit.  Sounds like sdc got kicked first.
> So...I would do a bad-block scan on sdb2 so it can remap the bad section and re-build as you've been trying to do.
> 
> If you REALLY want to use sda and sdc just rebuild the array with --create and leave sdb out of it.  You shouldn't lose much data if
> sdc is current.

Better still, do that --assemble and leave sdb out of it.
i.e.

 mdadm --assemble --force /dev/md1 /dev/sda2 /dev/sdc2

Then it will have to use a2 and c2.

NeilBrown
