From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Quick RAID 1+0 advice
Date: Thu, 1 Feb 2018 18:41:30 +0800
Message-ID: <a0e5cbd5-1ce8-e288-6263-8e272e95aea2@fnarfbargle.com>
References: <7c9c45b6-94b8-d97e-ee1b-e1a6bd4aff32@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c9c45b6-94b8-d97e-ee1b-e1a6bd4aff32@fnarfbargle.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/01/18 22:08, Brad Campbell wrote:

> So, my question is :
> 
> - If I stack RAID1 & RAID0 will I reliably pass discard down the stack 
> from an Ext4 filesystem right now with a current kernel?
> 

After getting some drives to test, the answer to that is yes.

Regards,
Brad
