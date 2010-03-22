From: Graeme Gemmill <graeme@gemmill.name>
Subject: Re: mdadm problem
Date: Mon, 22 Mar 2010 10:56:23 +0000
Message-ID: <4BA74CD7.2070607@gemmill.name>
References: <4BA664BA.20505@gemmill.name> <1f0f1a961003211151l2a30b256g471c60cc61d14ec2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f0f1a961003211151l2a30b256g471c60cc61d14ec2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tom Carlson <twigathy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/03/10 18:51, Tom Carlson wrote:
> On 21 March 2010 18:26, Graeme Gemmill<graeme@gemmill.name>  wrote
> some stuff....
>    
>> Some RAID expertise would be very welcome!
>>      
> I'm no expert... but I think you need to do the following:
> mdadm --stop /dev/md127
> mdadm --zero-superblock /dev/sd[a-c]
> mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sda1 /dev/sdb1 /dev/sdc1
>
> All the best,
>
> T
>    
Maybe not, Tom, but you're clearly well on the way to becoming one!
Steps 1& 2 worked, but the create step failed because mdadm said it 
couldn't recognise /dev/sda1.
However a reboot later and it worked.
Thanks,
Graeme
