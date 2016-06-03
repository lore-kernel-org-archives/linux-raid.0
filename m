From: bobzer <bobzer@gmail.com>
Subject: Re: raid 5 crashed
Date: Fri, 3 Jun 2016 11:27:41 -0400
Message-ID: <CADzS=aowHsk5LhoFMBXaVy5=nBBF5iMn6Axoq8z=okHTo=b9hQ@mail.gmail.com>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk> <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
 <574C8EB9.3070706@youngman.org.uk> <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
 <574D958F.8060209@turmel.org> <574DDCBD.40801@youngman.org.uk>
 <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com> <CACsGCyQuPEXtgeW6QH-s_-eW9-SZ3J5s2s7CUzZRNemexTt3aw@mail.gmail.com>
 <20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com> <574F00F5.80801@youngman.org.uk>
 <2f3e2fe6-1810-e7bd-7dc0-483ed4f0d46b@fnarfbargle.com> <57503C3F.6020005@youngman.org.uk>
 <40b1ed1e-b0bd-a496-b5c8-6ad1f370b3ee@fnarfbargle.com> <alpine.DEB.2.02.1606030947180.28955@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1606030947180.28955@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm still trying to recover my data, i did a dd_rescue of the
partition only (i regret that, i don't know why i didn't took the
whole disk :-(  )
unluckily me i got problem to be able to see all the disk i need in my
serveur (it's a vm and i miss sata port on the host)
i got a sata controller card which is not a recognize by esxi but
perfectly working with linux so i'm using gparted live
in gparted live the version of mdadm is 3.4 28th january 2016 , on my
serveur is mdadm - v3.3-78-gf43f5b3 - 02nd avril 2014

so i am asking myself is it better for me to try to rebuild my the
array from my original serveur or from gparted ?

i use losetup to make my dd image a dev/loop device and took the risk
of start the raid but it doesn't work:
i did :
mdadm --assemble --force --name=/dev/md0 /dev/sdb1 /dev/sdd1
/dev/loop2 /dev/sdc1
it answer :
mdadm: device /dev/sdb1 exist but is not an md array

except that is not true, sdb1 and sdd1 are the correct drive. sdc1 is
the one saw as a spare

so i don't know what to do :-(

thank you for your advice

PS: sorry for my english it's not my first language
