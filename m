From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Software RAID 0+1 with mdadm.
Date: Thu, 27 Jan 2005 16:24:34 +1100
Message-ID: <16888.31506.646380.934873@cse.unsw.edu.au>
References: <20050126151703.GA2040@percy.comedia.it>
	<OMEKLMBKKEOEENCKLEIDAECMCBAA.ryan@dynaconnections.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from J. Ryan Earl on Wednesday January 26
Sender: linux-raid-owner@vger.kernel.org
To: "J. Ryan Earl" <ryan@dynaconnections.com>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 26, ryan@dynaconnections.com wrote:
> This bug that's fixed in 1.9.0, is in a bug when you create the array?  ie
> do we need to use 1.9.0 to create the array.  I'm looking to do the same but
> my bootdisk currently only has 1.7.soemthing on it.  Do I need to make a
> custom bootcd with 1.9.0 on it?

This issue that will be fixed in 1.9.0 has nothing to do with creating
the array.

It is only relevant for stacked arrays (e.g. a raid0 made out of 2 or
more raid1 arrays), and only if you are using
   mdadm --assemble --scan
(or similar) to assemble your arrays, and you specify the devices to
scan in mdadm.conf as
   DEVICES partitions
(i.e. don't list actual devices, just say to get them from the list of
known partitions).

So, no: no need for a custom bootcd.

NeilBrown
