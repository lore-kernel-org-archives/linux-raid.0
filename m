From: Phil Turmel <philip@turmel.org>
Subject: Re: multiple disk failures in an md raid6 array
Date: Fri, 05 Apr 2013 08:05:35 -0400
Message-ID: <515EBE0F.5090201@turmel.org>
References: <17354834.2.1365150342620.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17354834.2.1365150342620.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org, Mike Vanhorn <michael.vanhorn@wright.edu>
List-Id: linux-raid.ids

On 04/05/2013 04:25 AM, Roy Sigurd Karlsbakk wrote:
>> for x in /sys/block/sd[cdfghij] ; do echo $x: $(< $x/device/timeout) ;
>> done >timeout.txt
> 
> I never made that one work. This one did, though
> 
> # for x in /sys/block/sd[cdfghij] ; do echo -n "$x: "; cat $x/device/timeout; done
> 
> Vennlige hilsener / Best regards

Curious.  Works fine here:

# for x in /sys/block/sd[abcd] ; do echo $x $(< $x/device/timeout) ; done
/sys/block/sda 30
/sys/block/sdb 30
/sys/block/sdc 30
/sys/block/sdd 30

Not that it matters, much.  Use what works for you.

Phil
