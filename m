From: David Greaves <david@dgreaves.com>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Thu, 01 May 2008 13:51:16 +0100
Message-ID: <4819BCC4.8030504@dgreaves.com>
References: <771640.4981.qm@web50209.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <771640.4981.qm@web50209.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: alex14641@yahoo.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Alex Davis wrote:
> Is this a bad thing? I'm guessing that it is, but I want independent
> confirmation before I spoke to someone I know who's doing this.
> 
> Thanks
Depends what you're trying to do.

It has the potential to increase i/o contention so it's not going to be a
performance win. Many systems really don't need to worry about performance. But
if you have 2x250 Gb drives and 1x500 Gb drive then your data is at less risk if
you partition the 500Gb into 2x250Gb and then mirror each partition with a full
250Gb disk. That would be a perfectly rational setup in many instances.

Equally, md has a mechanism to share hot spares amongst multiple RAIDs - but I
doubt that's what you meant.

David


