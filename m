From: Philip Molter <philip@corp.texas.net>
Subject: Force parity resync on raid5?
Date: Mon, 09 Aug 2004 18:10:34 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4118046A.1070002@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How do I force a parity resync on a raid5 array?  Under 2.4, I would do 
this by hard cycling the box and when it came back up, it would 
automatically resync the array.  Under 2.6, this appears to have gone away.

I suspect I have parity corruption on several boxes (they run fine 
normally, but when they lose a drive, they then get corrupted) related 
to the raid5 resync bug from an older kernel.  I want to force the 
parity to reinitialize since all the data is definitely good.

Thank you for any advice.
Philip
