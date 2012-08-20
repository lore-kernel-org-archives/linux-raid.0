From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: md raid behavior, bad sector uncorrectable read error
Date: Mon, 20 Aug 2012 16:53:27 +1200
Message-ID: <5031C2C7.3020604@clear.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Chris Murphy wrote:

 > Nor have I found in other documentation a reference to man md until
 > now.

The command

man -k KEYWORD

will search the whatis database for man pages containing KEYWORD, 
(assuming you have run "makewhatis", to generate a current database).

man -k md

or

man -k RAID

both return the md(4) man page.

Regards,

Richard
