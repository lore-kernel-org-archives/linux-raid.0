From: bobzer <bobzer@gmail.com>
Subject: Re: raid 5 crashed
Date: Fri, 3 Jun 2016 22:56:07 -0400
Message-ID: <CADzS=apvkaT_fxJ6=YFVHfqSGEAr9xuDbCZny6z5-u6ST=UJfA@mail.gmail.com>
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
 <CADzS=aowHsk5LhoFMBXaVy5=nBBF5iMn6Axoq8z=okHTo=b9hQ@mail.gmail.com> <5751B0E9.8040008@prgmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5751B0E9.8040008@prgmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sarah Newman <srn@prgmr.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> The --name is for if you want to call the device something other than just md0. If you use /dev/md0 instead of --name=/dev/md0 it might work.

thanks in fact it was just that ...
so i did :
mdadm --assemble --force /dev/md0 /dev/sdb1 /dev/sdc1 /dev/loop1 /dev/sdd1
and now i'm just hoping that it will work... every finger crossed :-)
