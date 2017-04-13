From: d tbsky <tbskyd@gmail.com>
Subject: Re: disk initialize priority
Date: Thu, 13 Apr 2017 18:38:33 +0800
Message-ID: <CAC6SzHLN40O5GcY08GEy5SBsDSu1WEhgx4WGG7aMs5AYbi1OYA@mail.gmail.com>
References: <CAC6SzHJAM-AbCiK7rqhgk4CJcyZ4C-yW0kt_rr3hgk+F-WMCiQ@mail.gmail.com>
 <43e44c4b-37d6-9734-b323-5b432ef27d52@thelounge.net> <CAC6SzHKWeLMSn1Z3W0KyBaUw+5MLmnMxLbh130gxM071t8VeFw@mail.gmail.com>
 <fc31c172-f988-32a4-c9b2-93bc7f3bfc90@thelounge.net> <20170413150514.6b92d81f@natsu>
 <CAC6SzHLj4FL_=7FwSwvaziYAOs95hwhRgoG6qaZPvgMBsXJBsg@mail.gmail.com> <20170413153419.73377864@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170413153419.73377864@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-13 18:34 GMT+08:00 Roman Mamedov <rm@romanrm.net>:
> On Thu, 13 Apr 2017 18:25:44 +0800
> d tbsky <tbskyd@gmail.com> wrote:
>
>>      RHEL 7 use kernel 3.10 so it should not be affected. at least
>> RHEL 7.2 I didn't notice this kind of problem. maybe RHEL 7.3 pull
>> some feature/patch from upstream kernel. I will try to report to
>> redhat bugzilla to see if they can fix these.
>
> Out of curiousity I checked the RHEL 7.3 kernel 3.10 source as available at:
> http://vault.centos.org/7.3.1611/updates/Source/SPackages/kernel-3.10.0-514.10.2.el7.src.rpm
> and yes indeed they have included that patch from the upstream 4.x kernel.
>
> --
> With respect,
> Roman

hi:
     you are really life saver. now I can easily report the bugs to redhat.
     thanks again for your patient and help!!

Regards,
tbskyd
