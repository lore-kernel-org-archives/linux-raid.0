From: jeffs_linux@123mail.org
Subject: Re: Why do I get different results for 'mdadm --detail' & 'mdadm
 --examine' for the same array?
Date: Wed, 15 Jun 2011 23:06:04 -0700
Message-ID: <1308204364.18753.1463722377@webmail.messagingengine.com>
References: <1307840471.18429.1462140465@webmail.messagingengine.com><20110616101812.761f7397@notabene.brown><1308184754.28723.1463652469@webmail.messagingengine.com><20110616112243.22a20610@notabene.brown><1308188856.14820.1463669409@webmail.messagingengine.com><20110616120049.2f01ce88@notabene.brown>
 <1308191963.29354.1463681709@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308191963.29354.1463681709@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

repeating the process on another box, i just noticed that these two
results' UUIDs match exactly,

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

what's happening here?  that can't be a coincidence.

is this a bug?  or maybe an artifact of the type of array?

jeff
