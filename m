From: Chris Friesen <cfriesen@nortelnetworks.com>
Subject: Re: Proposed Enhancements to MD
Date: Tue, 13 Jan 2004 15:29:45 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40045539.9040709@nortelnetworks.com>
References: <40036902.8080403@adaptec.com> <20040113081932.A721@lists.us.dell.com> <400436CC.7020007@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Scott Long <scott_long@adaptec.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> Matt Domsch wrote:
> 
>> I haven't seen the spec yet myself, but I'm lead to believe that
>> DDF allows for multiple logical drives to be created across a single
>> set of disks (e.g. a 10GB RAID1 LD and a 140GB RAID0 LD together on
>> two 80GB spindles), as well as whole disks be used.  It has a

How is this different than the 20GB RAID0 and 6 15BB RAID1s that I've 
got on two 100GB spindles right now?

I think its on 2.4, might even be 2.2.

Chris



-- 
Chris Friesen                    | MailStop: 043/33/F10
Nortel Networks                  | work: (613) 765-0557
3500 Carling Avenue              | fax:  (613) 765-2986
Nepean, ON K2H 8E9 Canada        | email: cfriesen@nortelnetworks.com

