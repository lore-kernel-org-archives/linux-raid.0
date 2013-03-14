From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Putting grub back on new mirror disk
Date: Thu, 14 Mar 2013 15:07:42 -0600
Message-ID: <E1690A73-C20E-4EB9-97E9-ACDC22AE9904@colorremedies.com>
References: <5141361F.7010505@vorgon.com> <CAD4F9C5-6A55-421A-BFAD-B23D72662054@colorremedies.com> <51423AAA.1070404@vorgon.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51423AAA.1070404@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 14, 2013, at 3:01 PM, "Timothy D. Lenz" <tlenz@vorgon.com> wrote:

> Had a couple minutes, so here is the paste for just sda.
> 
> http://pastebin.com/5eMJELyx

It's looking at the device.map, and it's also considering md0 as a grub device which doesn't seem correct. Try:

grub-install --recheck /dev/sda


Chris Murphy