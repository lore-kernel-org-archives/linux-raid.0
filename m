From: Mircea Ciocan <mirceac@interplus.ro>
Subject: Re: Please help with a special RAID 1 setup
Date: Wed, 07 Jan 2004 22:21:27 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FFC6A47.6060207@interplus.ro>
References: <E5DA6395B8F9614EB7A784D628184B207E14D1@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E5DA6395B8F9614EB7A784D628184B207E14D1@hdsmsx402.hd.intel.com>
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cress, Andrew R wrote:

>Well, the simplest thing would be to detach one of the mirror disks,
>keep it as the backup, then insert a new one for the resync.  Is that
>what you want?
>
>Andy
>  
>
    Well yes but I don't want to change phisically the wires, so I can 
detach a slice via sowtware, but new slice will be a different device ( 
on another controller), do you thing this is possible and how ( I try 
now to grok Luca's solution but not yet ready).

    Mircea

