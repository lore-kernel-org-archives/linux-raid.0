From: Andi Kleen <andi@firstfloor.org>
Subject: Re: limits on raid
Date: 17 Jun 2007 15:00:24 +0200
Message-ID: <p738xaisplj.fsf@bingen.suse.de>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<467273AB.9010202@argo.co.il>
	<18035.3009.568832.785308@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18035.3009.568832.785308@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:
> 
> Having the filesystem duplicate data, store checksums, and be able to
> find a different copy if the first one it chose was bad is very
> sensible and cannot be done by just putting the filesystem on RAID.

Apropos checksums: since RAID5 copies/xors anyways it would
be nice to combine that with the file system. During the xor
a simple checksum could be computed in parallel and stored
in the file system.

And the copy/checksum passes will hopefully at some
point be combined.

-Andi
