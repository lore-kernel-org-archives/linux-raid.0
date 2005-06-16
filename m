From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: Smart and SATA with FC4
Date: Thu, 16 Jun 2005 14:57:40 -0700
Message-ID: <42B1F5D4.3000204@ucolick.org>
References: <42B1A8EB.6060805@ucolick.org> <200506161051.27648.hjm@tacgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506161051.27648.hjm@tacgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <hjm@tacgi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Harry Mangalam wrote:

>on the unpatched kernel, have you tried forcing the smartctl to see the disks 
>as ATA devices:
>
>smartctl -a -d ata /dev/sd[etc]
>            ^^^^^^
>Using Ubuntu's 2.6.10-5-amd64-generic (unsure if it has been patched), I was 
>surprised that this worked great, including being able to force long tests to 
>the disks.
>  
>
yeah, i did try using the -d ata option, but it made no difference. But 
like I said, I don't know if there's also something to do with 
smartmontools. Which version are you using?

/Patrik

