From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Building RAID5 w/o a Hot Spare
Date: Wed, 27 Jan 2010 16:14:06 +0100
Message-ID: <87ockf37i9.fsf@frosties.localdomain>
References: <d80f793f1001270626s3ec1791ma0b5da4b87a31e34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1001270626s3ec1791ma0b5da4b87a31e34@mail.gmail.com>
	(Carlos Williams's message of "Wed, 27 Jan 2010 09:26:50 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Williams <carloswill@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Williams <carloswill@gmail.com> writes:

> I am building a Linux system which has 4 identical 'fd' partitions on
> each of the 4 drives. I don't want to use the 4th partition or disk if
> you would like to call it as a 'hot spare'. I would like to span the
> entire array over the 4 drives. My question is does my command look
> correct for doing so?
>
> mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/sda2 /dev/sdb2
> /dev/sdc2 /dev/sdd2
>
> I shouldn't have to specify any additional flags in the 'mdadm'
> command to make sure it uses all 4 drives as the RAID5 array, right?

No, it will use 4 drives as specified. Linux mdadm doesn't get ideas on
its own. It does what you tell it to do. :)

MfG
        Goswin

PS: sda2 is usualy not the 4th partition on a drive
