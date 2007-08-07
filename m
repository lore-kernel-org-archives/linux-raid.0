From: "saeed bishara" <saeed.bishara@gmail.com>
Subject: Re: Linux RAID migration
Date: Tue, 7 Aug 2007 16:27:44 +0300
Message-ID: <c70ff3ad0708070627r3a20f8faud8fd3cca9f87195@mail.gmail.com>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com>
	 <5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com>
	 <c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com>
	 <18104.18410.623573.929770@notabene.brown>
	 <c70ff3ad0708070332n33296a9cp719a6e1b8860ec4b@mail.gmail.com>
	 <c70ff3ad0708070346u4b538be9j6d1b5cf83f535de6@mail.gmail.com>
	 <18104.21737.341407.654022@notabene.brown>
	 <c70ff3ad0708070431v3ba47ab0j533197d92aea884c@mail.gmail.com>
	 <18104.23111.369229.891505@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18104.23111.369229.891505@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Tuomas Leikola <tuomas.leikola@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/7/07, Neil Brown <neilb@suse.de> wrote:
> On Tuesday August 7, saeed.bishara@gmail.com wrote:
> > On 8/7/07, Neil Brown <neilb@suse.de> wrote:
> > > On Tuesday August 7, saeed.bishara@gmail.com wrote:
> > > > how can I create raid 5 array that preserves the contents of a given
> > > > disk (part of the array)?
> > > > I can do that in two steps, raid 5 on two disks then reshape it to be
> > > > real raid5, but is there a direct way to do it?
> > >
> > > What do you mean by "real raid 5".  Two disks are just as much an
> > > array as 10.
> > I meant by real raid 5 to raid 5 over 3 drives or above.
> > > What do you mean by "direct".  If I understand your requirements
> > in one mdadm command
> > > correctly, there are two obvious steps.
> > >   1/ make the data appear in a raid5
> > >   2/ change the number of devices in the raid5.
> > >
> > > Are two steps too many?
> > in this case I two options:
> > 1. keep the filesystem unmounted tell step 1 in done -> the fs will
> > not be available for long time
>
> No, it shouldn't take a long time....
>
> What exactly do you have, and what exactly do you want to achieve?
>
> If think you started of by saying you wanted to convert a raid1 to a
> raid5.  Yes, that requires the filesystem to be unmounted, but only
> takes seconds to achieve:
>
>  mdadm -S /dev/md0
>  mdadm -C /dev/md0 -l5 -n2 /dev/sda1 /dev/sdb1
>  mount /dev/md0
>
> If you have a single-disk, you first might need to shrink the
> filesystem to make sure there is 128K free at the end of the device:
>
>   umount /filesystem
>   resize2fs /dev/sda1 whatever-number
>   mdadm -C /dev/md0 -l5 -n1 /dev/sda1 missing
-n1 didn't work, but -n2 succeeded.
>   mount /dev/md0 /filesystem
>   # now add the drives and grow
>   mdadm /dev/md0 --add /dev/sdb1 /dev/sdc1
>   # wait for recovery to finish
>   mdadm --grow /dev/md0 --raid-disks=3
>
> something like that..
great, this actually does the migration from single drive to raid5 as
I was looking for.
thanks.
>
> NeilBrown
>
