From: Gil <gil@fooplanet.com>
Subject: Re: mdadm-2.1-1.i386.rpm and linux-gate.so.1
Date: Tue, 18 Oct 2005 03:55:43 -0700
Message-ID: <4354D4AF.8010700@fooplanet.com>
References: <434BCA8A.8030303@panix.com> <17230.13761.247780.898679@cse.unsw.edu.au> <4354C75C.3040707@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4354C75C.3040707@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

berk walker wrote:
> Neil Brown wrote:
>> I suggest you just rebuild mdadm.rpm from the source.
>>
>>  rpm -ta mdadm-2.1.tgz
>>
>> NeilBrown
>>
>>  
>>
> [berk@berk downloads]$ rpm
> RPM version 4.3.2
> Copyright (C) 1998-2002 - Red Hat, Inc.
> [actually, 4.3.2-21]
> [berk@berk downloads]$ rpm -ta mdadm-2.1.tgz
> -ta: unknown option
> hmmm -  'preciate the try -Next?

Try rpmbuild -ta mdadm-2.1.tgz

All the build options were removed from rpm a while back.

