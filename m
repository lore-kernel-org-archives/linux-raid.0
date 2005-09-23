From: Norman Schmidt <schmidt@naa.net>
Subject: mdadm 2.0 and 2.1 compile error
Date: Fri, 23 Sep 2005 19:03:36 +0200
Message-ID: <43343568.7000304@naa.net>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I am trying to compile the mdadm source (from 
http://www.cse.unsw.edu.au/~neilb/source/mdadm/mdadm-2.x.tgz) under SuSE 
9.3 (64bit) on an opteron system.

On "make" I get the following fatal error for both 2.0 and 2.1:

bitmap.c: In function `bitmap_fd_read':
bitmap.c:130: warning: int format, different type arg (arg 3)
make: *** [bitmap.o] Error 1

What is the problem and how can I fix it?

Tia, Norman Schmidt.
-- 
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
                         IT-Systembetreuer Physikalische Chemie
