From: Jules Bean <jules@jellybean.co.uk>
Subject: Re: boot time autoassembly: how come it works?
Date: Thu, 05 Jun 2008 07:22:20 +0100
Message-ID: <4847861C.20901@jellybean.co.uk>
References: <4847119C.3070002@jellybean.co.uk> <20080604222740.GA32075@atlantis.cc.ndsu.NoDak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080604222740.GA32075@atlantis.cc.ndsu.NoDak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bryan Mesich wrote:
> I'm not sure I've seen a system auto assemble an array when the
> partitions were not set to 0xfd.  My bet is that you have a
> mdadm.conf file in your initrd and that the init script is
> starting the array in user space via mdadm.

Yes, there is an mdadm.conf and a full copy of mdadm in my initramfs.

However the mdadm.conf is wrong. weird.

It has the wrong number of devices listed for both arrays, and the wrong 
UUIDs. Somehow that must be close enough to work.

Jules
