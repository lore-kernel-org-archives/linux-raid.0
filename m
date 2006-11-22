From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Isn't raid1 obsolete by raid10 module?
Date: Wed, 22 Nov 2006 16:40:04 +0300
Message-ID: <45645334.4070203@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just out of curiosity.  It looks like raid10 module
provides all the functionality of raid1 too.  For
example, for a 2-component raid1 array, the two:

 mdadm -C -l1 -n2 /dev/md1 /dev/sda1 /dev/sdb1

and

 mdadm -C -l10 -n2 -ln2 /dev/md1 /dev/sda1 /dev/sdb1

will create the same array.  Ditto for e.g 3-component
raid1:

 mdadm -C -l1 -n3 /dev/md1 /dev/sd{a,b,c}1

and

 mdadm -C -l10 -n3 -ln3 /dev/md1 /dev/sd{a,b,c}1

will do the same.

Shouldn't raid1 module be removed from kernel? :)

/mjt
