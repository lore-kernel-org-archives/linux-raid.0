From: Mike Hardy <mhardy@h3c.com>
Subject: Re: how to clone a disk
Date: Sat, 11 Mar 2006 15:08:39 -0800
Message-ID: <44135877.2000207@h3c.com>
References: <1142038562.20484.234.camel@localhost.localdomain>	 <dd43dcfb0603110353g1a4d51f6y9fe4caa4007b6e9c@mail.gmail.com>	 <op.s581hroxcigqcu@apollo13>  <4413011F.30709@h3c.com> <1142114991.27020.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1142114991.27020.9.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: PFC <lists@peufeu.com>, "Paul M." <paul@gpmidi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids




Ming Zhang wrote:
> On Sat, 2006-03-11 at 08:55 -0800, Mike Hardy wrote:
> 
>>I can think of two things I'd do slightly differently...
>>
>>Do a smartctl -t long on each disk before you do anything, to verify
>>that you don't have single sector errors on other drives
> 
> 
> will this test interfere with normal disk io activity?

If I understand the documentation correctly, it is not supposed to
interfere with normal I/O. It's something the disk does when it can.

Also, I do it on running systems with busy disks all the time (it's
scheduled, actually, and runs automatically at the same time backups and
things like that happen), and it is never noticable to me.

*except* when it finds something, and it tells me there's a problem
before any software notices. I love the advance warning...

-Mike
