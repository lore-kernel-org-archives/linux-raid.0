From: Asdo <asdo@shiftmail.org>
Subject: Re: Several steps to death
Date: Tue, 26 Jan 2010 14:36:23 +0100
Message-ID: <4B5EEFD7.2080407@shiftmail.org>
References: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
 <4B5EB5BD.7070406@shiftmail.org>
 <5931ac0a02f59a2a2e1db82c630ff474.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <5931ac0a02f59a2a2e1db82c630ff474.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

aragonx@dcsnow.com wrote:
> Wow.
>
> I tried several times to assemble the array but I was not aware that it
> has to be in the same order.  That explains a lot.  Time for a hardware
> RAID controller.  :)  Thank you for the information.
>   

"--assemble" does not need drives to be specified in the correct order, 
but "--create" on an existing array will be destructive on existing data 
unless drives are specified in the same order as before.
