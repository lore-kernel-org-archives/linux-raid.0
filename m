From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: active/active vs active/passive?
Date: Tue, 07 Jun 2005 20:54:36 -0400
Message-ID: <42A641CC.9040905@steeleye.com>
References: <1118189397.15459.108.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1118189397.15459.108.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Stromberg wrote:
> The lecturer at the recent NG storage talk at Usenix in Anaheim,
> indicated that it was best to avoid "active/active" and get
> "active/passive" instead.
> 
> Does anyone:
> 
> 1) Know what these things mean?

In the clustering world, active/active means 2 or more servers are 
active at a time, either operating on separate data (and thus acting as 
passive failover partners to each other), or operating on the same data 
(which requires the use of a cluster filesystem or other similar 
mechanism to allow coherent simultaneous access to the data).

> 2) Know why active/passive might be preferred over active/active?

Well, if you're talking about active/passive vs. active/active with a 
cluster filesystem or such, the active/passive is tons easier to 
implement and get right. Plus, depending on your application, the added 
complexity of a cluster filesystem might not actually buy you much more 
than you could get with, say, NFS or Samba (CIFS).

--
Paul
