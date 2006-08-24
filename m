From: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: Linux: Why software RAID?
Date: Wed, 23 Aug 2006 23:20:35 -0600
Message-ID: <44ED3723.3090308@nortel.com>
References: <44ED1E41.40606@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44ED1E41.40606@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, marc@perkel.com
List-Id: linux-raid.ids

Jeff Garzik wrote:

> But anyway, to help answer the question of hardware vs. software RAID, I 
> wrote up a page:
> 
>     http://linux.yyz.us/why-software-raid.html

Just curious...with these guys 
(http://www.bigfootnetworks.com/KillerOverview.aspx) putting linux on a 
PCI NIC to allow them to bypass Windows' network stack, has anyone ever 
considered doing "hardware" raid by using an embedded cpu running linux 
software RAID, with battery-backed memory?

It would theoretically allow you to remain feature-compatible by 
downloading new kernels to your RAID card.

Chris
