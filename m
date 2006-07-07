From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Array will not assemble
Date: Fri, 07 Jul 2006 13:42:43 +1200
Message-ID: <44ADBC13.9010500@sauce.co.nz>
References: <44AD9F2B.9090205@sauce.co.nz> <17581.42401.473236.453490@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17581.42401.473236.453490@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

> Add
>   DEVICE /dev/sd?
> or similar on a separate line.
> Remove
>   devices=/dev/sdc,/dev/sdd

Thanks.

My mistake, I thought after having assembled the arrays initially, that 
the output of:

  mdadm --detail --scan > mdadm.conf

could be used directly.

I'm using Centos 4.3, which I believe is the latest RHEL 4 and they are 
only on mdadm 1.6  :(

Regards,

Richard
