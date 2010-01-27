From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
  !!
Date: Thu, 28 Jan 2010 08:33:47 +1300
Message-ID: <4B60951B.5050002@sauce.co.nz>
References: <4B5F6C73.30707@texsoft.it> <4B6000F0.2000405@shiftmail.org> <4B6010F5.6030702@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6010F5.6030702@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: Asdo <asdo@shiftmail.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Giovanni Tessore wrote:

> I didn't setup smart monitoring... Luca is right.
> But I dont like the idea that md relies on another tool, that could be
> not installed or correctly configured, to warn the user on potential
> critical situations which involve directly itself.

Or you build systems around a controller* that works with smartd, only 
to find that smartd support breaks in later kernel versions and finding 
suitable replacements has proven difficult. :(

*LSI SAS

http://marc.info/?l=linux-scsi&m=125293858330877&w=2

https://bugzilla.redhat.com/show_bug.cgi?id=512613

Regards,

Richard
