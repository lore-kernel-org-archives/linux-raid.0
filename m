From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH 0/3] md bitmap-based asynchronous writes
Date: Thu, 17 Mar 2005 15:51:22 -0500
Message-ID: <4239EDCA.4030502@steeleye.com>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <16949.5768.392061.95882@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These three patches provide the ability to perform asynchronous writes 
with raid1. The asynchronous write capability is primarily useful when 
raid1 is employed in network replication (i.e., with one or more of the 
disks located on a remote system). It allows us to acknowledge writes 
before they reach the remote system, thus making much more efficient use 
of the network.

The kernel patches build on the md bitmap code and the 
117WriteMostly-update patch. The first patch provides the framework for 
async writes. The second implements async writes for raid1. The third 
patch (for mdadm) provides the write-mostly updates and the ability to 
configure raid1 arrays for async writes.

Thnaks,
Paul
