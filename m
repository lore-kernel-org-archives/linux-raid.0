From: George Rapp <george.rapp@gmail.com>
Subject: Re: More information on linux raid partition problem
Date: Fri, 19 Feb 2016 09:43:11 -0500
Message-ID: <CAF-Kpgb8GTUASEyYQwG9TU+E+RppmM=BbwgG1grmL--M7NfbkA@mail.gmail.com>
References: <CAM1AHSyqg=0JRt4Ju352foV2M9gjTHMW5y94Dfj-h+96mKT1Jg@mail.gmail.com>
 <56C5F6A4.4040205@digitallyhosted.com> <CAM1AHSwBhjcaQ5dOfu7nfYQGtwQ0RGzGuFdo6ALB44aArGPLSQ@mail.gmail.com>
 <56C5FED9.9080001@mpstor.com> <CAM1AHSzs0T5RcYstEq-3koZ12=JPthf-XnmgH37=N=UtON9F3w@mail.gmail.com>
 <CAF-KpgZSXV08qofWkWzrtJr8dG9QvZ6JDxW+wypxkijqWnsLdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgZSXV08qofWkWzrtJr8dG9QvZ6JDxW+wypxkijqWnsLdA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: d c <c866e866e@gmail.com>
Cc: Benjamin ESTRABAUD <be@mpstor.com>, "Admin@DH" <admin@digitallyhosted.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 19, 2016 at 9:40 AM, George Rapp <george.rapp@gmail.com> wrote:
> On Thu, Feb 18, 2016 at 1:03 PM, d c <c866e866e@gmail.com> wrote:
>>
>>      mdadm --assemble /dev/md0 /dev/sdd2 /dev/sde2
>>      mdadm: cannot open device /dev/sde2: Device or resource busy
>>      mdadm: /dev/sde2 has no superblock - assembly aborted
>
> Donald -
>
> Try "mdadm --stop /dev/md0" before --assemble. Even though md0 is
> inactive, it still locks its component partitions.
>
> I don't see /dev/sde2 in the truncated output of /proc/mdstat - is it
> possible it's being used for something else other than the md0 array?
>
Sorry for replying to myself, but I noticed something further down in
the thread. Because the event counts on /dev/sdd2 and /dev/sde2 are
different, you may need to add --force to your mdadm --assemble
command.

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
