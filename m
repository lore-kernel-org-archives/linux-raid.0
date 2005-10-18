From: berk walker <berk@panix.com>
Subject: Re: mdadm-2.1-1.i386.rpm and linux-gate.so.1
Date: Tue, 18 Oct 2005 05:58:52 -0400
Message-ID: <4354C75C.3040707@panix.com>
References: <434BCA8A.8030303@panix.com> <17230.13761.247780.898679@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17230.13761.247780.898679@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:

>On Tuesday October 11, berk@panix.com wrote:
>  
>
>>so - rpm says mdadm depends on the so.1  Is this a problem with my 
>>system/configuration, or in the rpm?
>>    
>>
>
>Probably the RPM.  I built in under Debian/unstable.
>Google finds plenty of refs for linux-gate.  It is some magic 2.6
>thing.
>
>I suggest you just rebuild mdadm.rpm from the source.
> 
>  rpm -ta mdadm-2.1.tgz
>
>NeilBrown
>
>  
>
[berk@berk downloads]$ rpm
RPM version 4.3.2
Copyright (C) 1998-2002 - Red Hat, Inc.
[actually, 4.3.2-21]
[berk@berk downloads]$ rpm -ta mdadm-2.1.tgz
-ta: unknown option
hmmm -  'preciate the try -Next?

b-

