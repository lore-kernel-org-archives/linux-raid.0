From: Gordon Henderson <gordon@drogon.net>
Subject: Max. md array size under 32-bit i368 ...
Date: Wed, 24 May 2006 09:21:52 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0605240913410.16780@lion.drogon.net>
References: <200605221746.38122.Dexter.Filmore@gmx.de>
 <17522.17186.715844.748238@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17522.17186.715844.748238@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I know this has come up before, but a few quick googles hasn't answered my
questions - I'm after the max. array size that can be created under
bog-standard 32-bit intel Linux, and any issues re. partitioning.

I'm aiming to create a raid-6 over 12 x 500GB drives - am I going to
have any problems?

(I'm not parittioning the resulting md device, just the underlying sd
devices and building a single md out of  sd[a-l]4 ...)

Cheers,

Gordon
