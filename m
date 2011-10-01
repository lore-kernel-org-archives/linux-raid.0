From: David Brown <david.brown@hesbynett.no>
Subject: Re: Safely swapping a disk in a RAID456
Date: Sat, 01 Oct 2011 16:53:25 +0200
Message-ID: <j679h5$g42$1@dough.gmane.org>
References: <20110930154217.GA11732@albatross.gern.madduck.net> <20110930162811.GE30935@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110930162811.GE30935@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/09/11 18:28, Andre Noll wrote:
> On Fri, Sep 30, 17:42, martin f krafft wrote:
>> Does anyone have any ideas?
>
> Create a 2-disk Raid1 (with external metadata) containing the disk
> you'd like to replace and the replacement disk.
>
> And yes, it would be great if md provided an easier way to do this.
>

That would be "hot replace", which is quite high up on the md/mdadm 
"things to do" list.

<http://neil.brown.name/blog/20110216044002#2>


