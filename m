From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [klibc] Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 19:53:42 -0800
Message-ID: <43DEDF46.2060505@zytor.com>
References: <43DEB4B8.5040607@zytor.com> <20060131032133.GA8920@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030220AbWAaDx4@vger.kernel.org>
In-Reply-To: <20060131032133.GA8920@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Greg KH wrote:
> 
> What are you looking for exactly?  udev has a great helper program,
> volume_id, that identifies any type of filesystem that Linux knows about
> (it was based on the ext2 lib code, but smaller, and much more sane, and
> works better.)
> 
> Would that help out here?
> 

It might, but it's also rather ugly to have two pieces of code, 
especially in the presence of very dynamic partitions.  In other words, 
if the kernel deals with partitions, you want to be able to get at the 
kernel's view of partitions, not necessarily the actual set of 
partitions on disk, which can be quite different.

	-hpa
