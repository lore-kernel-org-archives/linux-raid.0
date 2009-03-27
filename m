From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID5 reshape problems : SOLVED
Date: Fri, 27 Mar 2009 19:11:18 +0100
Message-ID: <49CD16C6.301@xunil.at>
References: <49CA787C.2090100@xunil.at> <18890.44146.95223.103114@notabene.brown> <49CAB3A3.7020807@xunil.at> <49CB2799.7000305@xunil.at> <49CB56F0.9030902@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49CB56F0.9030902@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stefan G. Weichinger schrieb:
> I will wait until it isn't degraded anymore before I do the "pvresize".

Just for the records (maybe I need to google this myself someday ;) ):

The whole process finished this afternoon, with all 6 disks in the
raid5. The following pvresize worked without a problem as well.

So everything is fine again, it really seems that dust was the main
problem here ...

Thanks, Stefan
