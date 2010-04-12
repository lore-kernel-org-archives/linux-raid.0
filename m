From: =?windows-1252?Q?Tom=E1=9A_Dul=EDk?= <dulik@unart.cz>
Subject: Re: raid10,f2 Add a Controller: Which drives to move?
Date: Mon, 12 Apr 2010 05:41:36 +0200
Message-ID: <4BC29670.6020504@unart.cz>
References: <loom.20100411T185315-118@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100411T185315-118@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael McCallister <mike@mccllstr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I am not sure if I understand your question, but I suppose you will hit 
the problem of udev naming of your disks, and if your disks are 
hotswap-able, then also the problem of hotswap, which is currently 
discussed here in this mailing list.

I have spent too much time trying to solve both these problems with the 
current linux SW RAID (mdadm v. 2.6) and here is the first part of my 
solution:
http://wiki.debian.org/Persistent_disk_names

The page is still not really  finished, I am still playing with my 
server so the documentation must wait.


Michael McCallister napsal(a):

> So with four drives sda, sdb, sdc, and sdd and two controllers C1 and C2, should
> I go with
>
>     C1: sda, sdb
>     C2: sdc, sdd
>
> or
>
>     C1: sda, sdc
>     C2: sdb, sdd
>
> or some other configuration?
>   

