From: Chris Murphy <lists@colorremedies.com>
Subject: Re: grub and mdadm
Date: Mon, 10 Mar 2014 20:34:37 -0600
Message-ID: <E4045A48-C2C6-4C73-8CC8-6A7D82C45DCC@colorremedies.com>
References: <531D0637.4080009@shaw.ca> <AE60B6C3-B0BD-45C7-93EB-8E3C50D4300C@colorremedies.com> <531E3AFA.7080502@shaw.ca>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <531E3AFA.7080502@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Garboge <garboge@shaw.ca>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Please reply to the list also.


On Mar 10, 2014, at 4:21 PM, Garboge <garboge@shaw.ca> wrote:

> Thanks Chris, I was not clear in presenting my situation. The machine I'm working on is a different machine starting from scratch.
> 
> I should have asked if there is anyway of installing Lubuntu 12.10 on a block device mdadm raid. I actually get to the point of installing grub. Is what I'm asking possible?

I have no idea, but even if it can be done doesn't mean it should be done. I suspect upstream GRUB would say, BIOS Boot inside md raid isn't supported.

Two GRUBs cannot be embedded on BIOS computers. You can chainload one from the other using the multiboot command, or you can use configfile. Each distribution makes substantial changes to the upstream GRUB package, so ultimately any GRUB question quickly turns into a distro specific GRUB question.


Chris Murphy