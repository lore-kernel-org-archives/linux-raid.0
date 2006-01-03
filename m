From: Ric Wheeler <ric@emc.com>
Subject: Re: disk light remains on
Date: Tue, 03 Jan 2006 08:01:32 -0500
Message-ID: <43BA75AC.6010306@emc.com>
References: <20060103033213.GB7888@adsl-64-142-29-25.sonic.net> <20060103044914.GB8876@lug.udel.edu> <20060103052147.GA8380@adsl-64-142-29-25.sonic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060103052147.GA8380@adsl-64-142-29-25.sonic.net>
Sender: linux-raid-owner@vger.kernel.org
To: debian@good-with-numbers.com
Cc: Ross Vandegrift <ross@jose.lug.udel.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

debian@good-with-numbers.com wrote:
> Thanks for the reply.
> 
> On Mon, Jan 02, 2006 at 11:49:14PM -0500, Ross Vandegrift wrote:
> 
>>>I just began using RAID-1 (in 2.6.12) on a pair of SATA drives, and
>>>now the hard disk drive light comes on during booting--about when the
>>>RAID system is loaded--and stays on.
>>

There was a bug in libata that did not clear the register that set the 
drive light - you should be able to get rid of this issue with an 
updated kernel or simply ignore it,

ric
