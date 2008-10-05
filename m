From: Jeffrey Ross <jeff@bubble.org>
Subject: Re: RAID issue (Fedora 9 issue?)
Date: Sun, 05 Oct 2008 06:59:51 -0400
Message-ID: <48E89E27.3030102@bubble.org>
References: <48E81A7A.4080703@bubble.org> <48E88DB2.9060503@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48E88DB2.9060503@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



David Greaves wrote:
>
>> I have verified the contents of the
>> /etc/mdadm.conf file that the UUID's are correct
>>     
>
> Which mdadm.conf? The one on /dev/md6?
> Youy need to check/update the one in the initrd.
>
> Shouldn't have changed though unless you did a rebuild or something.
>   

uh... you nailed it... the mdadm.conf in the initrd (which I didn't 
realize existed) was out of sync with the /etc/mdadm.conf and had the 
incorrect UUID numbers.  I had mistakenly updated it installed a kernel 
update then realized it was wrong corrected it back but didn't rebuild 
the initrd file.
>> What has changed?  Not 100% sure, I have installed a handful of new
>> patches recently since the last reboot and unfortunately I don't know
>> which ones so there are a lot of possibilities.
>>     
> OK
> Kernel patches? Or rpms?
>   
The answer is yes to both, but obviously it was due to my (incorrect) 
tinkering.
> David
>
>   
Thank you again... its always nice to learn something new about the system.

Jeff
