From: Xiao Ni <xni@redhat.com>
Subject: Re: The dev node can't be released at once after stopping raid
Date: Wed, 30 Aug 2017 23:55:17 -0400 (EDT)
Message-ID: <1941784023.3852671.1504151717389.JavaMail.zimbra@redhat.com>
References: <1159964415.16461871.1496288839399.JavaMail.zimbra@redhat.com> <43bca632-9d77-2063-603c-6dcf47f3d250@suse.com> <1471667815.16472496.1496296238179.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1471667815.16472496.1496296238179.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

I have searched in history emails and there have many topics like this. Sorry for talking
about this again. But it looks like the situation I encountered is different. There is 1 second
window between stop the raid device and delete the node /dev/md0. The /dev/md0 node can be
removed successfully after 1 second. 

There is no process that open the /dev/md0 after mdadm -S /dev/md0: 

mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1 --assume-clean
dmesg:
[36416.860525] Opened by mdadm, pid is 3523
[36416.984160] md/raid1:md0: active with 2 out of 2 mirrors
[36416.984181] md0: detected capacity change from 0 to 523239424
[36416.984219] Released by mdadm, pid is 3523
[36416.984228] remove_and_add_spares
[36416.991588] Opened by mdadm, pid is 3541
[36416.997183] Released by mdadm, pid is 3541
[36417.001376] Opened by systemd-udevd, pid is 3525
[36417.007128] Released by systemd-udevd, pid is 3525

udev:
KERNEL[36419.830817] add      /devices/virtual/bdi/9:0 (bdi)
KERNEL[36419.831045] add      /devices/virtual/block/md0 (block)
UDEV  [36419.832911] add      /devices/virtual/bdi/9:0 (bdi)
UDEV  [36419.836380] add      /devices/virtual/block/md0 (block)
KERNEL[36419.877705] change   /devices/virtual/block/loop0 (block)
KERNEL[36419.878057] change   /devices/virtual/block/loop0 (block)
KERNEL[36419.926761] change   /devices/virtual/block/loop1 (block)
KERNEL[36419.927015] change   /devices/virtual/block/loop1 (block)
UDEV  [36419.953112] change   /devices/virtual/block/loop0 (block)
UDEV  [36419.953141] change   /devices/virtual/block/loop1 (block)
KERNEL[36419.954765] change   /devices/virtual/block/md0 (block)
UDEV  [36419.955973] change   /devices/virtual/block/loop0 (block)
UDEV  [36419.962799] change   /devices/virtual/block/loop1 (block)
UDEV  [36419.982934] change   /devices/virtual/block/md0 (block)

mdadm -S /dev/md0
dmesg:
[36493.068054] Opened by mdadm, pid is 3552
[36493.072051] Released by mdadm, pid is 3552
[36493.076123] Opened by mdadm, pid is 3552
[36493.080073] md0: detected capacity change from 523239424 to 0
[36493.080077] md: md0 stopped.
[36493.273011] Released by mdadm, pid is 3552
udev:
KERNEL[36496.300219] remove   /devices/virtual/bdi/9:0 (bdi)
KERNEL[36496.300335] remove   /devices/virtual/block/md0 (block)
UDEV  [36496.300736] remove   /devices/virtual/bdi/9:0 (bdi)
UDEV  [36496.301812] remove   /devices/virtual/block/md0 (block)

There are only REMOVE events during command mdadm -S /dev/md0.

I tried to create a lvm and remove it to check whether lvm has this problem or not. 

pvcreate /dev/md0 
vgcreate vg /dev/md0 
lvcreate -L 100M -n test vg
lvremove vg/test -y
ls /dev/mapper/vg-test
ls /dev/dm-3

The node /dev/mapper/vg-test and /dev/dm-3 can be removed in time. There is no time
window. So it looks like it's a problem of md. Could you give some suggestions about
this? What should I do next? 

If it's not a bug, why there is a 1 second window?

Best Regards
Xiao

----- Original Message -----
> From: "Xiao Ni" <xni@redhat.com>
> To: "Zhilong Liu" <zlliu@suse.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Thursday, June 1, 2017 1:50:38 PM
> Subject: Re: The dev node can't be released at once after stopping raid
> 
> 
> 
> ----- Original Message -----
> > From: "Zhilong Liu" <zlliu@suse.com>
> > To: "Xiao Ni" <xni@redhat.com>, linux-raid@vger.kernel.org
> > Sent: Thursday, June 1, 2017 12:43:49 PM
> > Subject: Re: The dev node can't be released at once after stopping raid
> > 
> > 
> > 
> > On 06/01/2017 11:47 AM, Xiao Ni wrote:
> > > Hi all
> > >
> > > I tried with the latest linux stable kernel and latest mdadm.
> > >
> > > After stopping a raid device, the dev node directory can't be released
> > > at once. I did a simple test, the script is:
> > >
> > > #!/bin/sh
> > >
> > > while [ 1 ]; do
> > > mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1
> > > sleep 5
> > > mdadm -S /dev/md0
> > > ls /dev/md0
> > > sleep 1
> > > ls /dev/md0
> > > done
> > >
> > > mdadm: stopped /dev/md0
> > > /dev/md0
> > > ls: cannot access /dev/md0: No such file or directory
> > >
> > > It usually detects dev node /dev/md0 isn't released after stopping raid.
> > > I'm not sure whether it's a bug or not. Do we need to do some job to
> > > make sure that the node should be released before command mdadm -S
> > > return?
> > 
> > it's waiting for processing the udev events. we can monitor it via to "#
> > udevadm monitor".
> > 
> > For mdadm -S /dev/md0, Manage_stop() has already did the errno checking,
> > 
> > cut piece of code from Manage.c
> > .. .. .. ..
> > done:
> > 
> >      /* As we have an O_EXCL open, any use of the device
> >       * which blocks STOP_ARRAY is probably a transient use,
> >       * so it is reasonable to retry for a while - 5 seconds.
> >       */
> >      count = 25; err = 0;
> >      while (count && fd >= 0 &&
> >             (err = ioctl(fd, STOP_ARRAY, NULL)) < 0 && errno == EBUSY) {
> >          usleep(200000);
> >          count --;
> >      }
> 
> Hi Zhilong
> 
> Good suggestions. I tried it and it can add some codes in the script to wait.
> Is it better to check the udev events in mdadm? Let's check it after closing
> mdfd when Manage_stop returns. Because it's mdadm's job, right?
> 
> Regards
> Xiao
> > 
> > Best regards,
> > -Zhilong
> > 
> > > Best Regards
> > > Xiao
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
