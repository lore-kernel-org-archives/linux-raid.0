From: "jeff sacksteder" <jsacksteder@gmail.com>
Subject: emergency recovery
Date: Thu, 10 Apr 2008 02:29:12 -0400
Message-ID: <51c8a7be0804092329i3353055ai6216dc0e6b4066ea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a root raid-5 set that has failed 2 disks simultaneously. This
is catastrophically bad news. I'm not sure what happened, but the
disks spin up and appear to function independently without problem.
The superblocks are all out of sync if I look at them with mdadm
examine.

It is essential that I not make this worse than it is. Is the
information in the wiki current regarding recovery of  failed arrays?
Are there any other resources I should be looking at?
