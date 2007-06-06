From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: Customize the error emails of  `mdadm --monitor`
Date: Wed, 06 Jun 2007 16:24:31 +0200
Message-ID: <4666C39F.6040504@rabbit.us>
References: <46619542.6010507@rabbit.us> <46669B20.6030706@rabbit.us> <20070606121121.GA23486@teal.hq.k1024.org> <4666A743.3050900@rabbit.us> <20070606141035.GA9404@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070606141035.GA9404@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gabor Gombas wrote:
> On Wed, Jun 06, 2007 at 02:23:31PM +0200, Peter Rabbitson wrote:
> 
>> This would not work as arrays are assembled by the kernel at boot time, at 
>> which point there is no udev or anything else for that matter other than 
>> /dev/sdX. And I am pretty sure my OS (debian) does not support udev in 
>> initrd as of yet.
> 
> But I think sending mails from the initrd isn't supported either, so if
> you already hack the initrd, you can get the path information from
> sysfs. udev is nothing magical, it just walks the sysfs tree and calls
> some little helper programs when collecting the information for building
> /dev/disk; you can do that yourself if you want.
> 
> Gabor
> 

I think I did not make my problem clear enough. The _device name_ 
reported in the emails is the one with which the array was initially 
assembled. For this I have two choices:

* Kernel auto-assembly - the parts are properly detected and assembled, 
but there is no strong relationship between component number and sdX, 
especially if asynchronous scsi scanning takes place.

* Assembly by mdadm.conf - I can put whatever block devices I want in 
there, and they will be preserved in the email, but it is very 
cumbersome to do it for root and other system partitions.

So I was asking if the component _number_, which is unique to a specific 
device regardless of the assembly mechanism, can be reported in case of 
a failure.

