From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Sat, 01 Mar 2008 15:18:29 -0500
Message-ID: <47C9BA15.20104@tmr.com>
References: <1204195554.16924.16.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1204195554.16924.16.camel@franck-gusty>
Sender: linux-raid-owner@vger.kernel.org
To: Franck Routier <franck.routier@axege.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Franck Routier wrote:
> Hi,
>
> I am installing a database (postgresql) server.
> I am considering two options:
> - either setup two 6 disks raid10 arrays
> - or setup three 4 disks raid10 arrays
>   

One more thought on this, if you use is such that you have one table 
which is really getting heavy read use, have more than two copies. Bad 
for disk utilization, good for having the data on an idle spindle.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


