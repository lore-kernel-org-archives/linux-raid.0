From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm --dangerous-no-resync equivalent
Date: Thu, 10 Mar 2005 12:14:50 +1100
Message-ID: <16943.40842.628321.801174@cse.unsw.edu.au>
References: <1110416418.4371.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from flame on Thursday March 10
Sender: linux-raid-owner@vger.kernel.org
To: flame <flame@ivt.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 10, flame@ivt.com.au wrote:
> Hi,
> 
> I have an installer (http://sourceforge.net/projects/terraformix/) that
> creates Raid 1 arrays, previously the arrays were created with mkraid
> using the --dangerous-no-resync option. I am now required to build the
> arrays with mdadm and have the following questions ;
> 
> 1) Is there an equivalent of --dangerous-no-resync in mdadm ?

No, though there might be one day, in which case it would be
     --assume-clean
(which works with --build, but is currently ignored for --create).

> 
> 2) Can I just go ahead and install onto a newly created RAID 1 array
> without waiting for it to resync ?

Yes.

> 
> 3) Can I just go ahead and install onto a newly created RAID 5 array
> without waiting for it to resync ?

Yes.


> 
> Thanks in advance.

You're welcome.

NeilBrown
