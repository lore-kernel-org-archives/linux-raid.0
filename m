From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: update mdadm version to 3.3.2 in Centos 6.4
Date: Tue, 03 Feb 2015 08:19:37 -0500
Message-ID: <wrfjtwz3t9na.fsf@redhat.com>
References: <CAKtQoftv3uf-Y1va7QV=qFiJZO0CdSJ7QtfHj7P1Mg5oyj0fRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKtQoftv3uf-Y1va7QV=qFiJZO0CdSJ7QtfHj7P1Mg5oyj0fRw@mail.gmail.com>
	(alpha lin's message of "Mon, 2 Feb 2015 22:30:39 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: alpha lin <lin.alpha@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

alpha lin <lin.alpha@gmail.com> writes:
> Hi All,
>
>     I would like to know the possibility of update the mdadm package
> from 3.2.5 to 3.3.2 in Redhat Centos 6.4 x64 system.
>     The problem I have is I found that I can create a raid volume
> without any problem. But when reboot the system. The md volume become
> inactive.
>     Below is my step:
>     1. Check out mdadm package from the github.
>     2. unzip the mdadm package and execute "make" and "make install"
>     3. reboot.
>     4. after system reboot, run mdadm to create a imsm RAID Volume.
>    [root@localhost rules.d]# mdadm --version
>     mdadm - v3.3.2 - 21st August 2014

Any reason why you haven't upgraded to centos 6.6? 6.4 is ancient, and
6.6 will at least come with mdadm-3.3.

Jes


