From: SoulBlazer <soul@lamp-post.net>
Subject: 2 HBA's and Multipath.
Date: Mon, 8 Apr 2002 14:02:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020408190441Z313735-22651+2113@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Question,

I have 2 Qlogic Fiberchannel HBA's (2100F's) connected directly to both FCAL 
ports on my Sun A5200 22 Disk disk array.  If I enable multipath, do I get 
twice the throughput between my linux box and the array ? Or is multipath 
purely for failover.

Additionally do I get twice the bandwidth anyhow since both HBA's see the 
same disk ?  How can I tell if either one or the other or both hba's are 
being utilized...

These are private loops being run in full duplex.



