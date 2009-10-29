From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: small mdadm issue under debian
Date: Thu, 29 Oct 2009 01:24:58 -0600
Message-ID: <200910290124.59090.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've been trying to get mdadm to auto assemble my raid array for a while 
now, and as I'm trying to test which kernels give me back some performance 
(testing 2.6.26 right now), I find that with this kernel, its happily auto 
assembling my 1.1 versioned metadata array. 3.6.30 does not, nor does .31 or 
.32 for that matter. Same version of mdadm, for some reason, when the
mdadm-raid init script is run, it fails to assemble the raid array I've 
specified in mdadm.conf. And again, it automagically works with 2.6.26.

color me confused.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
