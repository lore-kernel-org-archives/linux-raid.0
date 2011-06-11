From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Triple-parity raid6
Date: Sat, 11 Jun 2011 12:13:12 +0200
Message-ID: <20110611101312.GA3528@lazy.lzy>
References: <isp2g2$rf$1@dough.gmane.org>
 <20110609114954.243e9e22@notabene.brown>
 <isqb2o$g0s$1@dough.gmane.org>
 <20110609220438.26336b27@notabene.brown>
 <87aadq5q1l.fsf@gmail.com>
 <isslla$o2i$1@dough.gmane.org>
 <4DF20C18.3030604@christoph-d.de>
 <ist9n7$khq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ist9n7$khq$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[snip]
> Of course, all this assume that my maths is correct !

I would suggest to check out the Reed-Solomon thing
in the more friendly form of Vandermonde matrix.

It will be completely clear how to generate k parity
set with n data set (disk), so that n+k < 258 for the
GF(256) space.

It will also be much more clear how to re-construct
the data set in case of erasure (known data lost).

You can have a look, for reference, at:

http://lsirwww.epfl.ch/wdas2004/Presentations/manasse.ppt

If you search for something like "Reed Solomon Vandermonde"
you'll find even more information.

Hope this helps.

bye,

-- 

piergiorgio
