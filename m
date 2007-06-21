From: Nix <nix@esperi.org.uk>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 21:08:54 +0100
Message-ID: <87d4zp1355.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<467273AB.9010202@argo.co.il>
	<18035.3009.568832.785308@notabene.brown>
	<20070618045759.GD85884050@sgi.com>
	<18041.59628.370832.633244@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18041.59628.370832.633244@notabene.brown> (Neil Brown's message of "21 Jun 2007 03:57:09 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21 Jun 2007, Neil Brown stated:
> I have that - apparently naive - idea that drives use strong checksum,
> and will never return bad data, only good data or an error.  If this
> isn't right, then it would really help to understand what the cause of
> other failures are before working out how to handle them....

Look at the section `Disks and errors' in Val Henson's excellent report
on last year's filesystems workshop: <http://lwn.net/Articles/190223/>.
Most of the error modes given there lead to valid checksums and wrong
data...

(while you're there, read the first part too :) )

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
