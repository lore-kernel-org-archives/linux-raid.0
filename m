From: Neil Brown <neilb@suse.de>
Subject: Re: linear writes to raid5
Date: Thu, 27 Apr 2006 10:18:24 +1000
Message-ID: <17488.3536.48221.46658@cse.unsw.edu.au>
References: <m37j60udi8.fsf@bzzz.home.net>
	<17465.43983.345817.253532@cse.unsw.edu.au>
	<m3y7ybrffe.fsf@bzzz.home.net>
	<17468.18087.901186.523228@cse.unsw.edu.au>
	<m3hd4yrdx3.fsf@bzzz.home.net>
	<17474.53696.831154.37427@cse.unsw.edu.au>
	<4444F7A8.7050304@tls.msk.ru>
	<17478.52089.452739.896039@cse.unsw.edu.au>
	<444744E0.7010509@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Thursday April 20
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 20, mjt@tls.msk.ru wrote:
> Neil Brown wrote:
> > 
> > What is the rationale for your position?
> 
> My rationale was that if md layer receives *write* requests not smaller
> than a full stripe size, it is able to omit reading data to update, and
> can just calculate new parity from the new data.  Hence, combining a
> dozen small write requests coming from a filesystem to form a single
> request >= full stripe size should dramatically increase
> performance.

That makes sense.

However in both cases (above and below raid5), the device receiving
the requests is in a better position to know what size is a "good"
size than the client sending the requests.
That is exactly what the 'plugging' concept is for.  When a request
arrives, the device is 'plugged' so that it won't process new
requests, and the request plus any following requests are queued.  At
some point the queue is unplugged and the device should be able to
collect related requests to make large requests of an appropriate size
and alignment for the device.

The current suggestion is that plugging is quite working right for
raid5.  That is certainly possible.


> 
> Eg, when I use dd with O_DIRECT mode (oflag=direct) and experiment with
> different block size, write performance increases alot when bs becomes
> full stripe size.  Ofcourse it decreases again when bs is increased a
> bit further (as md starts reading again, to construct parity blocks).
> 

Yes.... O_DIRECT is essentially saying "I know what I am doing and I
want to bypass all the smarts and go straight to the device".
O_DIRECT requests should certainly be sized and aligned to make the
device.  For non-O_DIRECT it shouldn't matter so much.

NeilBrown
