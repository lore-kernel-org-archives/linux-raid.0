From: wimpunk <wim-raid@tisnix.be>
Subject: Re: how to move a raid1 drive to a new machine
Date: Mon, 10 Jan 2005 09:55:08 +0100
Message-ID: <41E242EC.5060908@tisnix.be>
References: <200501100343.01672.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501100343.01672.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Mitchell Laks wrote:
> Hi gurus,
> 
> A simple question. I have studied the documents
> 
> Software raid howto
> http://www.tldp.org/HOWTO/Boot+Root+Raid+LILO.html
> and scoured google.
> 
> Given a raid1 on a machine 
> 
> /dev/md0 consists of /dev/hdc and /dev/hde.
> 
> I want to grab one of those disks and move it to a new machine and make it 
> available there.

My experience: just put those drives in your new machine and it will 
run.  Btw, I didn't use any /etc/raidtab configuration, it worked out of 
the box.

> 
> What I have thought about:
> 
> turn off machine. grab /dev/hde. put in new machine say at position
> /dev/hdc (for grins).
> 
> now take an identical copy of /etc/raidtab from the original machine.
> install it as /etc/raidtab
> modprobe raid1
> mknod /dev/md0 b 9 0 (if necessary).
> raidstart /dev/md0
> 
> will this work? 

My partitions were autodetect (fd) and after loading the raid-modules it 
  worked fine...

> 
> questions:
> 1) when do i do mkraid /dev/md0 (ie what does that do... will it zap all the 
> stuff in /dev/hdc => ie what was on old /dev/hde??)

yep.

> 2) what is the mysterious failed-disk parameter in /etc/raidtab used for - ie 
> will it help here preserve the data while we start up the raid.

It's handy when you're moving from a normal disk to a raid-construction.

> 3) lets say i want to start the raid without a partner drive, ie just with 
> /dev/hdc ( "drive that used to be known as /dev/hde" "my apologies to glyph 
> who used to be Prince"), what do i do???

It starts with a failed disk.

> 
> Thanks,
> Mitchell
> 
>  
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
