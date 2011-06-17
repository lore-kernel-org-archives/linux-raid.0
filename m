From: jeffs_linux@123mail.org
Subject: Bug or not?  Same array reports different/transformed UUID depending on
 check-method used.
Date: Fri, 17 Jun 2011 09:29:49 -0700
Message-ID: <1308328189.28028.1464311105@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I suppose I should split this into its own thread rather than burying it
in my other.

Question first:

  I have two arrays attached to my Linux box.  Two methods of checking
  for arrays UUIDs give different results.  Why, and can I reply on
  these arrays?

Details follow:

Checking with,

 mdadm --incremental --rebuild-map
 mdadm --detail --scan
  ARRAY /dev/md/0_0 metadata=0.90                      
  UUID=52f5b43c:e83f7e2a:be6ad32e:0536ab0e
  ARRAY /dev/md127  metadata=1.2  name=jeffadm:jeffadm1
  UUID=d47afb79:e5fa9b28:ff35c586:f2602920

and,

 cat /dev/.mdadm/map
  md126 0.90 52f5b43c:e83f7e2a:be6ad32e:0536ab0e /dev/md/0_0
  md127 1.2  79fb7ad4:289bfae5:86c535ff:202960f2 /dev/md127

Staring at those UUIDs, I notice that one array's UUIDs match exactly
for the two methods of checking,

 /dev/.mdadm/map       /dev/md/0_0  52f5b43c:e83f7e2a:be6ad32e:0536ab0e
 mdadm --detail --scan /dev/md/0_0  52f5b43c:e83f7e2a:be6ad32e:0536ab0e

but the OTHER array's two UUIDs

 /dev/.mdadm/map       /dev/md127   79fb7ad4:289bfae5:86c535ff:202960f2
 mdadm --detail --scan /dev/md127   d47afb79:e5fa9b28:ff35c586:f2602920

are 'transforms' of one another; e.g.,

 mdadm --detail --scan /dev/md127   d47afb79:e5fa9b28:ff35c586:f2602920

                                    d4       e5
                                      7a       fa
                                        fb       9b
                                          79:      28:...

                                        |
                                        |  couplet order transform
                                        |

                                          d4       e5
                                        7a       fa
                                      fb       9b
                                    79:      28:      ...

 /dev/.mdadm/map       /dev/md127   79fb7ad4:289bfae5:86c535ff:202960f2

Why are /dev/md127's UUIDs, unlike /dev/md/0_0's, reporting mis-matched
& 'transformed'?

jeff
