From: Phil Turmel <philip@turmel.org>
Subject: Re: raid 5 crashed
Date: Tue, 31 May 2016 09:45:51 -0400
Message-ID: <574D958F.8060209@turmel.org>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
 <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
 <574C8EB9.3070706@youngman.org.uk>
 <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>, Anthonys Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 05/30/2016 06:00 PM, bobzer wrote:
> I did follow his advice for the smartctl i can't right now but i will
> post the output
> my drives are desktop grade normal seagate, not NAS nor entreprise so
> i will retry but i will limit the speed of reconstruction with :
> echo 40000 > /proc/sys/dev/raid/speed_limit_max
> echo 1000 > /proc/sys/dev/raid/speed_limit_min
> I hope that it will permit to finish the rebuilding

No, that is unlikely to help.  You need to read about "timeout mismatch"
as you clearly have a bad case of it.  This is not a new issue, as you
can see from the dates of the following:

http://marc.info/?l=linux-raid&m=139050322510249&w=2
http://marc.info/?l=linux-raid&m=135863964624202&w=2
http://marc.info/?l=linux-raid&m=135811522817345&w=1
http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=132477199207506
http://marc.info/?l=linux-raid&m=133665797115876&w=2
http://marc.info/?l=linux-raid&m=142487508806844&w=3
http://marc.info/?l=linux-raid&m=144535576302583&w=2
