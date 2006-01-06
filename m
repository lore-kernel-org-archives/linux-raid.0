From: PFC <lists@peufeu.com>
Subject: Re: Kanotix crashed my raid...
Date: Fri, 06 Jan 2006 13:02:09 +0100
Message-ID: <op.s2yg1vkdcigqcu@apollo13>
References: <fd8d0180601050104x15079396h@mail.gmail.com> <fd8d0180601050106s5f5b4306o@mail.gmail.com> <87oe2r2d93.fsf@rimspace.net> <fd8d0180601050321k19f12f53r@mail.gmail.com> <43BE3C99.4050706@ieee.org> <op.s2yecmeocigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s2yecmeocigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	I forgot :

	I tried these :

  	mdadm --assemble /dev/md2 /dev/hdb1 /dev/sd{a,b,c,d}1

	with --run, --force, and both, --stop'ping the array before each try, and  
everytime is the same error, and the same line in dmesg : "cannot start  
dirty degraded array for md2"


apollo13 ~ # mdadm --stop /dev/md2
apollo13 ~ # mdadm --assemble --verbose /dev/md2 /dev/hdb1  
/dev/sd{a,b,c,d}1

mdadm: looking for devices for /dev/md2
mdadm: /dev/hdb1 is identified as a member of /dev/md2, slot 4.
mdadm: /dev/sda1 is identified as a member of /dev/md2, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md2, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md2, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md2, slot 2.
mdadm: added /dev/sdb1 to /dev/md2 as 1
mdadm: added /dev/sdd1 to /dev/md2 as 2
mdadm: added /dev/sdc1 to /dev/md2 as 3
mdadm: added /dev/hdb1 to /dev/md2 as 4
mdadm: added /dev/sda1 to /dev/md2 as 0
mdadm: /dev/md2 assembled from 4 drives - need all 5 to start it (use  
--run to insist).
apollo13 ~ # mdadm --run /dev/md2
mdadm: failed to run array /dev/md2: Input/output error

apollo13 ~ # mdadm --stop /dev/md2
apollo13 ~ # mdadm --assemble --verbose --run /dev/md2 /dev/hdb1  
/dev/sd{a,b,c,d}1

mdadm: looking for devices for /dev/md2
mdadm: /dev/hdb1 is identified as a member of /dev/md2, slot 4.
mdadm: /dev/sda1 is identified as a member of /dev/md2, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md2, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md2, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md2, slot 2.
mdadm: added /dev/sdb1 to /dev/md2 as 1
mdadm: added /dev/sdd1 to /dev/md2 as 2
mdadm: added /dev/sdc1 to /dev/md2 as 3
mdadm: added /dev/hdb1 to /dev/md2 as 4
mdadm: added /dev/sda1 to /dev/md2 as 0
mdadm: failed to RUN_ARRAY /dev/md2: Input/output error

apollo13 ~ # mdadm --stop /dev/md2
apollo13 ~ # mdadm --assemble --verbose --run --force /dev/md2 /dev/hdb1  
/dev/sd{a,b,c,d}1

mdadm: looking for devices for /dev/md2
mdadm: /dev/hdb1 is identified as a member of /dev/md2, slot 4.
mdadm: /dev/sda1 is identified as a member of /dev/md2, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md2, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md2, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md2, slot 2.
mdadm: added /dev/sdb1 to /dev/md2 as 1
mdadm: added /dev/sdd1 to /dev/md2 as 2
mdadm: added /dev/sdc1 to /dev/md2 as 3
mdadm: added /dev/hdb1 to /dev/md2 as 4
mdadm: added /dev/sda1 to /dev/md2 as 0
mdadm: failed to RUN_ARRAY /dev/md2: Input/output error
