From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Tue, 03 Jul 2007 19:43:33 +0100
Message-ID: <468A98D5.9090206@dgreaves.com>
References: <200707012321.48346.infomails@tronserver.dyndns.org> <200707031916.50502.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707031916.50502.infomails@tronserver.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Frotscher <infomails@tronserver.dyndns.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Frotscher wrote:
> Hello all,
> 
> I guess you can say that I'm at my wit's end. I really don't get it. An RAID 
> array is suppose to recognize its members purely by its uuid, isn't it? So 
> technically, I can remove a drive from one bus, reconnect it to another 
> giving it a new device name and the array should not even need to sync.
> 
> Somehow it doesn't. Somehow the array remembers of which devices it's supposed 
> to be assembled and boots in degraded mode, funnily not always missing the 
> swapped drive.
> 
> Suppose I lose a whole ide-controller and want to restart the box with a 
> seconday controller? That one would surely not have the devices hda through 
> hdd and my array would refuse to start.
> 
> Does anyone have a suggestion of what I can try? Ok, the array runs fine as 
> long as it is connected to its original bus, but I really don't want to take 
> chances here.

Do you have a mdman.conf file that specifies/limits partitions to search?

David


