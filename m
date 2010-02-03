From: Keld Simonsen <keld@keldix.com>
Subject: recovering a mirrored arry.
Date: Wed, 3 Feb 2010 03:57:58 +0100
Message-ID: <20100203025758.GA12925@light.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I got 2 arrays in error of the raid10 type.

I think this is because my motherboard died, and then the fs were
corrupted.

My thoughts were tat actually one of the copies were correct.
So I would like to try out the consistency of each part of the raid10
(it is 2-partition arrys, and then if I find one that is consisten then
resync the faulty one with the good one.

How do I do this?

it seems that I cannot just assemble an array with a missing part.
If I assemble the full array, is there then a risk of the bad one
corrupting the good one? And can I declare one of the disks faulty
then test the oter one, then declare nbr 2 disk for faulty and 
declare the first one as good?

I dont see anything on the wiki on this.

best regards
keld
