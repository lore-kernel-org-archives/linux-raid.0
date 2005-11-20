From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: raid5 write performance
Date: Sun, 20 Nov 2005 14:54:33 -0500
Message-ID: <4380D479.2030203@steeleye.com>
References: <200511190440.jAJ4efw15919@www.watkins-home.com>	<437EB0A6.8040807@h3c.com>	<17278.48635.585763.580503@cse.unsw.edu.au> <17279.33422.273880.463498@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17279.33422.273880.463498@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho wrote:

> I think the demand for any solution to the unclean array is indeed low
> because of the small probability of a double failure. Those that want
> more reliability can use a spare drive that resyncs automatically or
> raid6 (or both).

A spare disk would help, but note that raid6 does not decrease the 
probability of the silent corruption problem. Losing one disk in a raid6 
still means that you are degraded (i.e., you rely on parity to 
recalculate data, so an incomplete stripe write means corruption).

--
Paul
