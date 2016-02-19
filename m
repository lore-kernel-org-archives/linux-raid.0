From: George Rapp <george.rapp@gmail.com>
Subject: Re: More information on linux raid partition problem
Date: Fri, 19 Feb 2016 14:31:21 -0500
Message-ID: <CAF-KpgZ5R_CWCTFVy+7g0DGhu+=eORpS4_KBNhYcB7W_uER2CQ@mail.gmail.com>
References: <CAM1AHSyqg=0JRt4Ju352foV2M9gjTHMW5y94Dfj-h+96mKT1Jg@mail.gmail.com>
 <56C5F6A4.4040205@digitallyhosted.com> <CAM1AHSwBhjcaQ5dOfu7nfYQGtwQ0RGzGuFdo6ALB44aArGPLSQ@mail.gmail.com>
 <56C5FED9.9080001@mpstor.com> <CAM1AHSzs0T5RcYstEq-3koZ12=JPthf-XnmgH37=N=UtON9F3w@mail.gmail.com>
 <CAF-KpgZSXV08qofWkWzrtJr8dG9QvZ6JDxW+wypxkijqWnsLdA@mail.gmail.com>
 <CAF-Kpgb8GTUASEyYQwG9TU+E+RppmM=BbwgG1grmL--M7NfbkA@mail.gmail.com> <CAM1AHSwOd0XU0gxaAUQsXYBreKowh4tnYe3ueVKVpgBWMCJOpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAM1AHSwOd0XU0gxaAUQsXYBreKowh4tnYe3ueVKVpgBWMCJOpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: d c <c866e866e@gmail.com>
Cc: Benjamin ESTRABAUD <be@mpstor.com>, "Admin@DH" <admin@digitallyhosted.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 19, 2016 at 2:01 PM, d c <c866e866e@gmail.com> wrote:
>
> George,
>
> Thank you for staying with me.  I tried both commands you sent to me,
> but still does not work.
>
> Here is my session:
>
> [root@server ~]# mdadm --stop /dev/md0
> mdadm: error opening /dev/md0: No such file or directory
> [root@server ~]#
> [root@server ~]# mdadm --assemble --force /dev/md0 /dev/sdd2 /dev/sde2
> mdadm: cannot open device /dev/sde2: No such file or directory
> mdadm: /dev/sde2 has no superblock - assembly aborted

The only other thing I can think to try is --re-add:

# mdadm --manage /dev/md0 --re-add /dev/sde2

Not sure if that will re-create the superblock, though.
-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
