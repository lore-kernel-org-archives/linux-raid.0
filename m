From: "Shaw, Marco" <Marco.Shaw@aliant.ca>
Subject: RE: ibm serveraid
Date: Fri, 7 Feb 2003 08:34:28 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C65F89D1AC0BB54B865127151A24DA780E49063A@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I want to compile new kernel with full support for the 
> controller. What i need? Is scsi support enough and all disk 
> array will work correctly? Or there should be some special 
> initialization during boot time and i need some special 
> features compiled in? Can i compile serverRAID support as a 
> module? I already have working system based on linux with 
> configured raid controller.

It's your choice how you compile in support (modular or monolithic).  Your output 
doesn't tell me a whole lot, so I'm thinking that your best bet is try a system 
without any boot arguments to see how things go.

Event though it's a very important part of the system, I typically stick with
modular...

Marco
