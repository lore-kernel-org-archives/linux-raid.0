From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: very strange behavior with RAID1 arrays on Ubuntu 12.04 (kernel
 3.2)
Date: Tue, 19 Jun 2012 13:48:37 -0400
Message-ID: <4FE0BB75.7000101@cdf.toronto.edu>
References: <4FD7AFC4.1020707@cdf.toronto.edu> <CAGRgLy5H_MZkjVVxUyKhNuvif3EQ6AxwhknaQPRBUKmj5qkrPA@mail.gmail.com> <4FDF97EA.5010309@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FDF97EA.5010309@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey guys,

Just a bit of extra information. It looks like this mdadm bug was the 
cause of our problem (at least the people on launchpad think it's a 
confirmed bug):

https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/925280

What do you think?

Cheers and thanks!
Iordan
