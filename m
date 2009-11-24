From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid10 disc-activity every five seconds
Date: Tue, 24 Nov 2009 11:12:09 +0000
Message-ID: <4B0BBF89.6040400@anonymous.org.uk>
References: <4B0BBDB4.1010403@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B0BBDB4.1010403@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Doits <markus.doits@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/11/2009 11:04, Markus Doits wrote:
> just wanted to silency my pc by reducing disk-activity. what bothers me
> is: my disk "click" about every five seconds.
[...]

Try mounting the filesystem that's on md2 with the noatime option.

Cheers,

John.

