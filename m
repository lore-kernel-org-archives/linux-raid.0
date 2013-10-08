From: Brian Candler <b.candler@pobox.com>
Subject: Re: Using mdadm instead of dmraid for BIOS-RAID root volume
Date: Tue, 08 Oct 2013 15:19:31 +0100
Message-ID: <52541473.4020005@pobox.com>
References: <5253F7C2.2030401@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5253F7C2.2030401@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 > Anyway, I'm not so worried about having broken this machine, as it 
needed a reinstall anyway, but I do wonder what would have been the 
correct way to get mdraid instead of dmraid at boot time for this root 
volume?

After some more searching, it looks like the udev rules were nobbled to 
disable this in
https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1030292

A possible way to re-enable is here:
https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1054948/comments/9

I'm a bit concerned about the issues around clean shutdown, and hence 
whether is really production-ready yet.

Regards,

Brian.

