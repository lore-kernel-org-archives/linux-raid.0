From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Moved drives between machines... now, MIA.
Date: Fri, 29 Jan 2010 13:52:48 -0500 (EST)
Message-ID: <b54b3e55942c56b2ec1f69d80f54eaea.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, so I swapped six drives from one machine to another.  I was very,
very careful to ensure that the drives were plugged in in the
corresponding order that they'd been plugged in in the first machine. 
Now, fdisk shows no partitions in two of my three mirrors.  This fills me
with a distinct lack of warmth and fuzziness.  /etc/mdadm/mdadm.conf
addresses the two (MIA) mirrors with /dev/sd[abef]1 designators, which
can, of course, get jumbled in a transition.  Any tips on how to go
forward would be gratefully appreciated -- I *really* don't want to have
to go to backups.

Thanks!

-Ken


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

