From: Johannes Puschmann <puschl@puschl.at>
Subject: RE: building network software raid
Date: Tue, 21 May 2002 21:31:16 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <210BDEC895C9D511A18D0000B493CEB4BD42@EXCHANGE>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'lylai' <lylai@csie.nctu.edu.tw>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi!
Take a look at
http://www.complang.tuwien.ac.at/reisner/drbd/

It may help you.

Best regards
Puschl


> -----Original Message-----
> From: lylai [mailto:lylai@csie.nctu.edu.tw]
> Sent: Tuesday, May 21, 2002 6:52 PM
> To: unlisted-recipients
> Cc: linux-raid
> Subject: building network software raid
> 
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
> 	/dev/md0: Invalid arguments
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
