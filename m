From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: how know, when disc goes down?
Date: Thu, 27 Mar 2003 14:30:54 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E82FD0E.5080108@hum.auc.dk>
References: <b5ue2n$nnr$1@main.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b5ue2n$nnr$1@main.gmane.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linux-raid-owner@vger.kernel.org wrote:
> Hello,
> i am using raid 5 since several months on a samba fileserver. How do i get
> information, when one of the discs goes down??

You can use mdadm i monitor mode: 
http://www.cse.unsw.edu.au/~neilb/source/mdadm/ with mdadm --monitor.

Best regards,
Mads Bach

