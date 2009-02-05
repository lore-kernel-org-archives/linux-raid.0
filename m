From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks reporting
 "No md superblock detected"?
Date: Thu, 05 Feb 2009 13:49:14 -0500
Message-ID: <498B34AA.5020606@tmr.com>
References: <1233775657.10151.5.camel@localhost.localdomain>	 <4989FF7B.6030503@scalableinformatics.com> <1233781437.696.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233781437.696.2.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: tjb@unh.edu
Cc: landman@scalableinformatics.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas J. Baker wrote:
> The array was made probably two years ago and had been working fine
> until recently. In reading the documentation for mdadm, it did seem like
> it should have required me to use the higher version but it never
> complained when I made it and worked fine.
>   

What have you changed lately? Are the drives all on a single controller? 
Are you using PARTITIONS in mdadm.conf and letting mdadm find things for 
itself?

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


