From: flame <flame@ivt.com.au>
Subject: mdadm --dangerous-no-resync equivalent
Date: Thu, 10 Mar 2005 12:00:18 +1100
Message-ID: <1110416418.4371.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have an installer (http://sourceforge.net/projects/terraformix/) that
creates Raid 1 arrays, previously the arrays were created with mkraid
using the --dangerous-no-resync option. I am now required to build the
arrays with mdadm and have the following questions ;

1) Is there an equivalent of --dangerous-no-resync in mdadm ?

2) Can I just go ahead and install onto a newly created RAID 1 array
without waiting for it to resync ?

3) Can I just go ahead and install onto a newly created RAID 5 array
without waiting for it to resync ?

Thanks in advance.

-- 
flame <flame@ivt.com.au>

