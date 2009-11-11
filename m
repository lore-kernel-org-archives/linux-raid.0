From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Thu, 12 Nov 2009 07:03:33 +1300
Message-ID: <4AFAFC75.3070307@sauce.co.nz>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com> <4AF9A89B.80400@sauce.co.nz> <200911110004.31238.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911110004.31238.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Fjellstrom wrote:

> Thats the problem he was trying to get away from. the MV8 controller likes 
> to offline disks when a few smart commands arrive. at least with the main 
> kernel drivers. But then the main kernel mvsas drivers decide to give up if 
> you even attempt to start a raid array on them. The controller locks up and 
> you have to reboot. Most of the time a reboot even fails when it tries to 
> sync the block devices, so a hard reset is in order.

OK, I did not know the Marvell controller also has a problem with 
smartmontools.

In his original post he mentions it having problems with mdadm:

"(mdadm freaks out on it and the controller drops the drives - there has 
been discussion of the problem on the list. Seems to be a mvsas driver 
problem but seems to surface only under mdadm use.)"

Regards,

Richard
