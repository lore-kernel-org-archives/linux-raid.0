From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Simple question, maybe
Date: Thu, 27 Jun 2002 04:02:13 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15642.421.825234.16918@notabene.cse.unsw.edu.au>
References: <1025113529.1793.8.camel@jason.storix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jason Shelton on  June 26
To: Jason Shelton <jason@storix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  June 26, jason@storix.com wrote:
> Hello, I'm sorry to bother all of you with what may be a trivial
> question, but I'm stumped. I work for a company that makes backup and
> recovery software and we have a need to boot a kernel that has Raid
> support built-in, but would like to tell the kernel not to autodetect
> the raid devices that may be on the system. Is there a way to do this?
> perhaps a lilo append string or something? 

 append="raid=noautodetect"

NeilBrown
