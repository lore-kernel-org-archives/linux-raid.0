From: Philipp Gortan <gortan@chello.at>
Subject: Re: One partition degraded after every reboot
Date: Fri, 02 Apr 2004 11:20:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406D3077.9010101@chello.at>
References: <406C00E3.4030205@chello.at> <20040401175218.GL9632@gaspode.nextlink.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040401175218.GL9632@gaspode.nextlink.co.za>
To: linux-raid@vger.kernel.org
Cc: Thomas Andrews <tandrews@grok.co.za>
List-Id: linux-raid.ids

Thomas Andrews wrote:

>># mkinitrd -k -r /dev/md0 -o /boot/initrd.img-2.6.3-1-k7
>>    
>>
>Yes I found I had to do that from the start because the initrd image
>from before the raid conversion was set up for a different root device,
>so in my case that isn't the solution.
>
>  
>
Hi Thomas,
well, I'd definitely give it another try now...

>I'm using grub. I wonder if that's a problem ?
>  
>
I'm no grub expert, but I didn't get it to work under grub either, so
I switched to lilo. Simply say
# apt-get install lilo
# liloconfig
accept the defaults and change the values in /etc/lilo.conf for boot and 
root to your root md device.
then run lilo and you should be set...

cu,
philipp


