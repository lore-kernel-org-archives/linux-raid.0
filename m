From: Iwan Zarembo <iwan@zarembo.de>
Subject: Re: IMSM Raid 5 always read only and gone after reboot
Date: Thu, 25 Aug 2011 21:16:05 +0200
Message-ID: <4E569F75.2020306@zarembo.de>
References: <CAOTVL7JLxjHgyaz0s3Ua9gsgUYHP_2b1DONzk3YNaCLfgxMBpA@mail.gmail.com>	<4E4B4075.2060400@gmail.com>	<4E553039.8010003@zarembo.de> <20110825095430.3b88d71d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110825095430.3b88d71d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> It sounds like mdmon is not being started.
> mdmon monitors the array and performs any metadata updates required.
>
> The reason mktable is taking more than a second is that it tries to write to
> the array, the kernel marks the array as 'write-pending' and waits for mdmon
> to notice, update the metadata, and switch the array to 'active'.  But mdmon
> never does that.
>
> mdmon should be started by mdadm but just to check you can start it by hand:
>
>   /sbin/mdmon md126
> or
>   /sbin/mdmon --all
>
> If this makes it work, you need to work out why mdmon isn't being started.
>
> NeilBrown
>
Hello NeilBrown,
I finally found it. I was using mdadm 3.1.4, it is in the repository of 
ubuntu. This version does not really support IMSM that this is the real 
problem. I found it because I did not have mdmon. It does not exists in 
this old version. So I downloaded the latest official relesae 3.2.1 and 
installed it via make && sudo make install. Now everything works 
perfectly. The array is available after reboot and the synchronization 
process works over BIOS and not over mdadm itself.
I would never found out that the version is making the trouble without 
your comment about mdmon. Thank you.

@Daniel,linbloke: Also a big thank you to you both. I learned a lot 
about raid with this problem.

Cheers,

Iwan

