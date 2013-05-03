From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Fri, 03 May 2013 18:28:02 +0200
Message-ID: <5183E592.6020409@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill wrote:
> The safest option would be:
>  - add in the new disks
>  - partition to at least the same size as your existing partitions (they
>    can be larger)
>  - add the new partitions into the arrays (they'll go in as spares)
>  - grow the arrays to 4 members (this avoids any loss of redundancy)
>  - wait for the resync to complete
>  - install grub/lilo/syslinux to the new disks
>  - fail and remove the old disk partitions from the arrays
>  - shrink the arrays back down to 2 members
>  - remove the old disks
> 
> Then, if you're keeping the same number of partitions but increasing the
> size:

Ok.. got here.

>  - grow the arrays to fill the partitions
>  - grow the filesystems to fill the arrays

Now the scary part.. so.. here I believe I should give the following 
commands:

mdadm --grow /dev/md0 --size=max
mdadm --grow /dev/md1 --size=max
mdadm --grow /dev/md2 --size=max

and after that

fsck /dev/md0
fsck /dev/md1
fsck /dev/md2

and

resize2fs /dev/md0
resize2fs /dev/md1
resize2fs /dev/md2

Correct?


.. I still have a couple of questions:

1) how do I know if there's a bitmap?

2) at present /dev/md2 usage is 100%.. could that cause any problem?

3) the new drives are 2TG drives.. As around one year ago had trouble on 
linux (it was a server dated 2006 with CentOS 5) that would not handle 
drives larger than 2TB.. I wander what happens if one day one drive 
fails and the drive I'll buy to replace will be sold as 2TB but in 
reality slightly larger than 2TB.. what will happen? Will linux fail 
again to use a drive larger than 2TB?
At present I'm on ubuntu 10.04, all software from standard distribution.

Pitfalls I should know?

Thank you very much
Robi
