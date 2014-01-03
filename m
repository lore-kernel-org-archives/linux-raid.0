From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 reshape integer problem
Date: Fri, 03 Jan 2014 07:56:46 -0500
Message-ID: <52C6B38E.8050804@turmel.org>
References: <loom.20140103T101338-556@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20140103T101338-556@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Piotr Klimek <piotr@klimek.net.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/03/2014 04:30 AM, Piotr Klimek wrote:
> Hello,
> I was trying to migrate from 5x3TB RAID5 to 6x3TB RAID6 with this command:
> 
> $ mdadm --grow /dev/md1 --level=6 --raid-devices=6 --
> backup=/home/archiwum/r6.bak
> 
> After couple of days reshape stalled on 2147483648 block. I have found that 
> this is a bug in mdadm. 2147483648 is max integer on 32 bit system. For now 
> situation looks like this:

You'll certainly have to take production down long enough to let a newer
kernel finish the reshape.  Or you could be brave and replace the kernel
and let production continue through the balance of the reshape.

HTH,

Phil
