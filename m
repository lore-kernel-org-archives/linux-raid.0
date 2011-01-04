From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: RAID for USB flash drives
Date: Tue, 04 Jan 2011 16:22:16 -0500
Message-ID: <4D238F88.7050908@cdf.toronto.edu>
References: <AANLkTi=kcbanFit5x27ccS_1RChxC=Dn+Hs4Ak+FbKsX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=kcbanFit5x27ccS_1RChxC=Dn+Hs4Ak+FbKsX@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Debirf is a project which allows one to create an initrd image which 
contains a complete Debian system.

We use debirf to create an image that we then boot from a single USB 
stick. We use this to boot a fleet of machines which export iscsi 
targets, so we don't have to waste a drive bay for the OS.

http://cmrg.fifthhorseman.net/wiki/debirf

For us, this solution works great, since there is absolutely NO wear on 
the stick - the entire OS runs in memory. However, this does mean that 
you would have to consider Debian rather than Ubuntu, or find a way to 
make debirf work under Ubuntu.

As far as constructing the RAID sets, I would look into using larger 
chunks. Our testing showed that in our environment where our requests 
are small (of size around 1 - 2kb), large 1MB chunks gave the best 
performance. Chunks of size 512kb were a close second in performance for us.

Booting over the network can create certain chicken-and-egg scenarios 
which again depend on your environment :).

Cheers,
Iordan
