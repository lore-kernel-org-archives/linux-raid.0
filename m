From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 02:47:16 +0200
Message-ID: <62b0912f0604161747x7254dbby9f4a3f21e4349b33@mail.gmail.com>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	 <17474.51121.178492.61143@cse.unsw.edu.au>
	 <62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com>
	 <17474.54168.331725.412456@cse.unsw.edu.au>
	 <17474.55148.614834.999648@fisica.ufpr.br>
	 <20060417002513.GR19700@zip.com.au>
	 <17474.58490.889579.654449@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17474.58490.889579.654449@fisica.ufpr.br>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho wrote:
> You want the array to stay on and jump here and there getting the
> stripes from wherever it can, each time from a different set of disks.
> That's surely nice but I think it's too much to ask...

With the bad block rate on modern disks as high as ever, I dare say
it's an absolutely obligatory feature.

If anyone knows how to do the above, I'm still looking for help :-).

Quoting meself:
=============
Trying to start with all 6 devices by hand:

# mdadm --assemble /dev/md1 --force  /dev/sda1 /dev/sdb1 /dev/sdc1
/dev/sdd1 /dev/sde1 /dev/sdf1
mdadm: /dev/md1 has been started with 5 drives (out of 6).

Ugh.  Didn't work.  Bug?

How do I force MD to raise the event counter on sdb1 and accept it
into the array as-is, so I can avoid bad-block induced data
corruption?
