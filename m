From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: CentOS 6.2 on partition able RAID1 (md_d0) - kernel panic with
 either disk not present
Date: Wed, 03 Oct 2012 15:23:47 +0100
Message-ID: <506C4A73.6050504@anonymous.org.uk>
References: <CAHhM8gBsxgYUwqOiVePKFb-epbTQwZDRH50HQy9PPaOMOY=Brw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHhM8gBsxgYUwqOiVePKFb-epbTQwZDRH50HQy9PPaOMOY=Brw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arun Khan <knura9@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/10/2012 12:17, Arun Khan wrote:
> I had posted the following in the CentOS General mailing list but the
> problem remains unresolved.
>
> Here is the link to the CentOS thread:
> <http://lists.centos.org/pipermail/centos/2012-June/126927.html>
>
> I am posting it here in the hope that some one will be able to help me
> pinpoint the "gotcha" and fix it.
>
> In case you are able to help, please read all the postings in the
> above thread, to see what others have suggested and what I have
> already tried, so as to avoid repetition of questions and answers.

Please post the full output of
   cat /proc/mdstat
   cat /etc/mdadm.conf
   mdadm -Evvs
   file -s /dev/sda
   file -s /dev/sda1
   file -s /dev/sdb
   file -s /dev/sdb1
   cat /etc/grub/grub.conf
(from inside the running VM, obviously).

I have to say I don't like the wiki article you quoted as a method of 
installation, but let's see if we can fix it before starting out doing 
it another way.

In addition, you probably ought to be testing on bare metal similar to 
your future production box.

Cheers,

John.
