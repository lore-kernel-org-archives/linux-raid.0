From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: raid 5 crashed
Date: Wed, 1 Jun 2016 13:28:44 +0800
Message-ID: <78cf1c9f-671b-727e-9ddd-607b6c8bc14e@fnarfbargle.com>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
 <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
 <574C8EB9.3070706@youngman.org.uk>
 <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
 <574D958F.8060209@turmel.org> <574DDCBD.40801@youngman.org.uk>
 <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com>
 <CACsGCyQuPEXtgeW6QH-s_-eW9-SZ3J5s2s7CUzZRNemexTt3aw@mail.gmail.com>
 <20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com>
 <CACsGCySR8NwbwRY=xe32YzyeZPFMmeDbnqp-LbykPoGBc537qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCySR8NwbwRY=xe32YzyeZPFMmeDbnqp-LbykPoGBc537qA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 01/06/16 13:23, Edward Kuns wrote:

>> I do daily short SMART tests, weekly long SMART tests and monthly "check"
>> scrubs of the RAID(s). I'm not saying it's best practice, but I've had
>> several drives turn up SMART failures and managed to address those before it
>> became an issue on any of the arrays.
>
> As far as SMART, I'm running with the default Fedora behavior in that
> area.  I don't believe it does any automatic tests, unless the default
> logwatch behavior does SMART tests.  I'll add this to my "todo" list.
> Thanks.

I just add this into smartd.conf on every machine I have (all Debian 
based systems). Make sure it's the first DEVICESCAN line as all lines 
after this are ignored.

Mail to brad, short tests every day at 2am and long tests at 4am on a 
Sunday.

DEVICESCAN -m brad -s (L/../../7/04|S/../.././02) -M exec 
/usr/share/smartmontools/smartd-runner

By default I've never had any system schedule smart tests.

