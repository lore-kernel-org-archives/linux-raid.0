From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: building network software raid
Date: Tue, 21 May 2002 14:16:24 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1022004984.3cea8ef8127dd@imap.linux.ibm.com>
References: <1021999937.3067.15.camel@chiayi.csie.nctu.edu.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1021999937.3067.15.camel@chiayi.csie.nctu.edu.tw>
To: lylai <lylai@csie.nctu.edu.tw>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Quoting lylai <lylai@csie.nctu.edu.tw>:

> I'm a student doing an OS project: build a software raid over the
> network.
> 
> I intend to use existing software RAID program. The plan is that build
> the raid on a device that is not a real physical device, but a device I
> made up. I'll handle the I/O request through the network.
> 
> I already wrote a simple device driver with all the required functions,
> and try to "mkraid" on the created new devices. But it failed with
> error:
> 
>  /dev/md0: Invalid arguments
> 
> I want to know what information is needed to make mkraid, ... etc. run
> properly that they see it as a true hard disk. And what operations are
> needed to pass these information out.
> 
> Thank you for your advices.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Try the following URL:
http://unthought.net/Software-RAID.HOWTO/

Mike Tran


