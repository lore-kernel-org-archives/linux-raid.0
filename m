From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: slow random raid5 access?
Date: Sat, 30 May 2009 13:44:15 -0600
Message-ID: <200905301344.15895.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm have a new md raid5 array, and have been trying to break it in and tweak 
it a little. But random read or write are rather slow when using small record 
sizes:

http://pastebin.ca/1441414

Is that normal? And is there a way to speed it up without significantly 
slowing down sequential access?

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
