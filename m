From: Xiao Ni <xni@redhat.com>
Subject: Re: The dev node can't be released at once after stopping raid
Date: Thu, 1 Jun 2017 01:50:38 -0400 (EDT)
Message-ID: <1471667815.16472496.1496296238179.JavaMail.zimbra@redhat.com>
References: <1159964415.16461871.1496288839399.JavaMail.zimbra@redhat.com> <43bca632-9d77-2063-603c-6dcf47f3d250@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43bca632-9d77-2063-603c-6dcf47f3d250@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "Zhilong Liu" <zlliu@suse.com>
> To: "Xiao Ni" <xni@redhat.com>, linux-raid@vger.kernel.org
> Sent: Thursday, June 1, 2017 12:43:49 PM
> Subject: Re: The dev node can't be released at once after stopping raid
> 
> 
> 
> On 06/01/2017 11:47 AM, Xiao Ni wrote:
> > Hi all
> >
> > I tried with the latest linux stable kernel and latest mdadm.
> >
> > After stopping a raid device, the dev node directory can't be released
> > at once. I did a simple test, the script is:
> >
> > #!/bin/sh
> >
> > while [ 1 ]; do
> > mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1
> > sleep 5
> > mdadm -S /dev/md0
> > ls /dev/md0
> > sleep 1
> > ls /dev/md0
> > done
> >
> > mdadm: stopped /dev/md0
> > /dev/md0
> > ls: cannot access /dev/md0: No such file or directory
> >
> > It usually detects dev node /dev/md0 isn't released after stopping raid.
> > I'm not sure whether it's a bug or not. Do we need to do some job to
> > make sure that the node should be released before command mdadm -S return?
> 
> it's waiting for processing the udev events. we can monitor it via to "#
> udevadm monitor".
> 
> For mdadm -S /dev/md0, Manage_stop() has already did the errno checking,
> 
> cut piece of code from Manage.c
> .. .. .. ..
> done:
> 
>      /* As we have an O_EXCL open, any use of the device
>       * which blocks STOP_ARRAY is probably a transient use,
>       * so it is reasonable to retry for a while - 5 seconds.
>       */
>      count = 25; err = 0;
>      while (count && fd >= 0 &&
>             (err = ioctl(fd, STOP_ARRAY, NULL)) < 0 && errno == EBUSY) {
>          usleep(200000);
>          count --;
>      }

Hi Zhilong

Good suggestions. I tried it and it can add some codes in the script to wait.
Is it better to check the udev events in mdadm? Let's check it after closing 
mdfd when Manage_stop returns. Because it's mdadm's job, right?

Regards
Xiao
> 
> Best regards,
> -Zhilong
> 
> > Best Regards
> > Xiao
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
