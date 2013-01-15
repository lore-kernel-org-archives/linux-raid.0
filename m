From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Mon, 14 Jan 2013 19:50:29 -0600
Message-ID: <50F4B5E5.30809@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301141122.15322.thomas@fjellstrom.ca> <50F46075.2090903@hardwarefreak.com> <201301141453.13819.thomas@fjellstrom.ca>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301141453.13819.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: Tommy Apel Hansen <tommyapeldk@gmail.com>, Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/14/2013 3:53 PM, Thomas Fjellstrom wrote:

> 
>                                                             random  random    bkwd   record   stride                                   
>               KB  reclen   write rewrite    read    reread    read   write    read  rewrite     read   fwrite frewrite   fread  freread
>         33554432    8192  124664  121973   524509   527971  376880  104357  336083    40088   392683   213941   215453  631122   631617
>
> I assume that is to you liking?

Yes, much better.  Now, where is the output from the system you're
comparing performance against?

> As for the simple home server array, if it were so simple, it'd work out
> of the box with no issues at all.

It is working.  And there are no issues, but for your subjective
interpretation of the iozone data, assuming it is not working properly.

This is why benchmarks of this sort are generally only good for
comparing one system to another.

-- 
Stan


