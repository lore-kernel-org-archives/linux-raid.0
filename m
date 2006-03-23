From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 that used parity for reads only when degraded
Date: Thu, 23 Mar 2006 11:13:54 +1100
Message-ID: <17441.59458.918847.175664@cse.unsw.edu.au>
References: <loom.20060323T003324-767@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alex Izvorski on Wednesday March 22
Sender: linux-raid-owner@vger.kernel.org
To: Alex Izvorski <aizvorski@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 22, aizvorski@gmail.com wrote:
> Hello,
> 
> I have a question: I'd like to have a raid5 array which writes parity data but
> does not check it during reads while the array is ok.  I would trust each disk
> to detect errors itself and cause the array to be degraded if necessary, in
> which case that disk would drop out and the parity data would start being used
> just as in a normal raid5.  In other words until there is an I/O error that
> causes a disk to drop out, such an array would behave almost like a raid0 with
> N-1 disks as far as reads are concerned.  Ideally this behavior would be
> something that one could turn on/off on the fly with a ioctl or via a echo "0" >
> /sys/block/md0/check_parity_on_reads type of mechanism.  
> 
> How hard is this to do?   Is anyone interested in helping to do this?  I think
> it would really help applications which have a lot more reads than writes. 
> Where exactly does parity checking during reads happen?  I've looked over the
> code briefly but the right part of it didn't appear obvious ;)

Parity checking does not happen during read.  You already have what
you want.

NeilBrown
