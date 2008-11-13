From: "Nick Pappin" <npappin@latahfcu.org>
Subject: 3 Disk Raid 1
Date: Wed, 12 Nov 2008 17:07:08 -0800
Message-ID: <65ac40811121707n1c0e75eem1a77dbb56a9d147d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,
     I have a three disk raid 1 array. Now I have it running perfectly
and I can do rebuilds on it however what I don't know is how does the
data scrubbing work on that machine. Normally in a raid 1 the bit
would be randomly assigned from one drive to the other but since there
are three would it look at all three drives and see if two match up
and then put the information from the two drives on to the third, or
how does that system work?

Nick
