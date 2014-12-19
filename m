From: Xiao Ni <xni@redhat.com>
Subject: Re: indefinite hang when growing/reshaping
Date: Fri, 19 Dec 2014 03:17:27 -0500 (EST)
Message-ID: <1538557949.678228.1418977047020.JavaMail.zimbra@redhat.com>
References: <CAJCQCtQWSVbx08xafh6MDikiJOZJ6MVJ4Jx=qt=UZnX3t47A7A@mail.gmail.com> <997573837.677557.1418976887168.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <997573837.677557.1418976887168.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <chris@colorremedies.com>
Cc: linux-raid@vger.kernel.org, eguan@redhat.com, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids


  Sorry, forget to say kernel version and mdadm version

[root@storageqe-19 home]# uname -r
3.18.1
[root@storageqe-19 home]# mdadm --version
mdadm - v3.3.2 - 21st August 2014


----- Original Message -----
> From: "Xiao Ni" <xni@redhat.com>
> To: "Chris Murphy" <chris@colorremedies.com>
> Cc: linux-raid@vger.kernel.org, eguan@redhat.com, "Jes Sorensen" <jes.sorensen@redhat.com>
> Sent: Friday, December 19, 2014 4:14:47 PM
> Subject: Re: indefinite hang when growing/reshaping
> 
> Hi all
> 
>    There is the same problem. I can reproduce with the same steps. And
> I can reproduce this in a different way too. I don't know whether it's
> the same problem, but the result is the same.
> 
>    The different steps are as follows:
> 
> mdadm -CR /dev/md0 -l5 -n7 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> /dev/sdf1 /dev/sdh1 -x1 /dev/sdi1  --assume-clean --bitmap=internal
> mdadm --grow -l0 /dev/md0  --backup-file=tmp0
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1] [raid0]
> md0 : active raid5 loop3[4] loop2[3] loop1[1] loop0[0]
>       2045952 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
>       [>....................]  reshape =  0.0% (0/1022976) finish=5.8min
>       speed=2818K/sec
>       
> unused devices: <none>
> 
>    There is speed 2818K/sec, but if you look by iostat, there is no speed
>    about the disks.
> 
> 
>    And there is a workaround:
>    mdadm -CR /dev/md0 -l5 -n7 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
>    /dev/sde1 /dev/sdf1 /dev/sdh1 -x1 /dev/sdi1  --assume-clean
>    --bitmap=internal
>    mdadm --grow -l0 /dev/md0
> 
>    If we don't specify the backup file. The reshape can finish correctly.
> 
> Best Regards
> Xiao
> 
> ----- Original Message -----
> > From: "Chris Murphy" <chris@colorremedies.com>
> > To: linux-raid@vger.kernel.org
> > Sent: Thursday, December 18, 2014 6:20:50 AM
> > Subject: indefinite hang when growing/reshaping
> > 
> > If this is user error I'd expect a discreet error message, but I don't
> > get one, just a hang during the reshape following successful --grow
> > command (going from 3x device raid5 to 4x device raid5).
> > 
> > # cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md127 : active raid5 loop3[4] loop2[3] loop1[1] loop0[0]
> >       2095104 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4]
> >       [UUUU]
> >       [>....................]  reshape =  0.0% (0/1047552)
> > finish=7.0min speed=2402K/sec
> > 
> > Reproduces with:
> > kernel-3.17.6-300.fc21.x86_64
> > mdadm-3.3.2-1.fc21.x86_64
> > and
> > 3.18.0-2.fc22.i686+debug
> > mdadm-3.3.2-1.fc21.i686
> > 
> > Details are here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=89851
> > 
> > --
> > Chris Murphy
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
