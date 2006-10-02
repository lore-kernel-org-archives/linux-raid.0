From: "Mark Ryden" <markryde@gmail.com>
Subject: mdadm and raidtools - noob
Date: Mon, 2 Oct 2006 13:53:41 +0200
Message-ID: <dac45060610020453j6b9e3cdeiad9a7fac71160dc6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello linux-raid list,

  I want to create a Linux Software RAID1 on linux FC5 (x86_64),
from SATA II disks. I am a noob in this.
	
  I am reading now chapter 26 ,"Linux Software Raid" ,
of "Linux Quick Fix Notebook" book
by Peter Harrison.

http://www.quickfixnotebook.com/

It talks in that chpater about using raidtools
(mkraid and /etc/raidtab config file) to do this.

I looked for it and saw that as far as I understand,
raidtools is quite old - from 2003.
for exanple, http://people.redhat.com/mingo/raidtools/

More than that, I saw that on my FC5, I did not have it at all.

Looking a bit more, I saw that there is installed mdadm util, which is
part of mdadm rpm.

"mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays."
according to:
http://www.cse.unsw.edu.au/~neilb/source/mdadm/ANNOUNCE

So my question is this:
is raidtools deprecated ?
Is it possible at all to use raidtool to create linux software RAID1,
running 2.6.17-1.2187_FC5 kernel on x86_64 ?
Is using mdadm is the way to create linux software RAID1 ? Is it the only way ?

Regards,
Mark Ryden
