From: "Alwin Bakkenes" <alwin.bakkenes@consat.se>
Subject: Raid-5 freezes with large writes... Continues after a more /proc/mdstat???
Date: Fri, 18 Jun 2004 15:02:32 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040618130243.21C742074@nw-smtp-05.wineasy.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hej, 

I am using Suse 9.1 and have build (finally) my Raid-5 volume using the
raidtools. 

When I write large amounts of data to the array (i.e. 50 GB) in a cp or mv
operation, it always stops in the middle of the copy. It waits. There are no
kernel messages, no errors, it just waits. 

The strange part is that after I do a "more /proc/mdstat" my cp/mv operation
continues. 

Performance is descent with approx. 20-30MB/s writes and 80MB/s reads. 

You can see the rest of my setup in a previous post:
http://marc.theaimsgroup.com/?l=linux-raid&m=108738559332187&w=2

Has anybody seen this before? 

Alwin

P.S. I am using two Maxtor 200GB IDE disks and two identical disks but with
SATA interface. My box is a Dell 400SC and I run Suse 9.1 with the default
kernel.


