From: Erik Wasser <erik.wasser@iquer.net>
Subject: 'Segmentation fault' after running 'mdadm --examine --brief --scan --config=partitions'
Date: Sun, 13 Mar 2005 13:22:29 +0100
Message-ID: <200503131322.29987.erik.wasser@iquer.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

I've got a problem here with the mdadm tools. I'm using on my system[1] 
the mdadm tools[2] and I just tried one of the examples of the manpage:

% mdadm --examine --brief --scan --config=partitions
Segmentation fault

I started up the ddd: in the routine 'load_conffile' the string "DEV 
partitions" will be passed to the routine 'devline'. And this routine 
pass this parameter to the macro 'dl_next' and I think (after seeing 
the definition of 'dl_next') this is brocken.

Can somebody confirm this bug? I don't know how to fix this so there is 
no patch in this mail sorry. B-(

[1] uname -a

Linux fuzz 2.6.10-gentoo-r6 #1 Sat Feb 5 09:56:14 CET 2005 i686 AMD 
Athlon(tm) XP 2800+ AuthenticAMD GNU/Linux

[2] Gentoo: sys-fs/mdadm-1.9.0-r1

-- 
So long... Fuzz
