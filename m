From: "Doug Griswold" <griswld@cio.sc.gov>
Subject: md multipath and failover
Date: Wed, 10 Sep 2003 18:55:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <sf5f73bb.058@gw.state.sc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alright I got md/multipath to failover with 2 emulex hba's on red hat
advanced server 2.1 kernel version 2.4.9-27enterprise.  My next new
problem is that it took five minutes to fail over from when I yanked one
of the fibre channel cables.   Where could this timeout come from?  I
have tried several times but each time it takes 5 minutes to failover. 
Also it won't failback.  Any ideas out there.  
