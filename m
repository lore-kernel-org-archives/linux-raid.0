From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: growing a RAID-10 array with mdadm 3.3.1+ ?
Date: Tue, 11 Oct 2016 19:50:13 +0100
Message-ID: <5770f398-8d8f-ec07-b630-dff93ab68312@youngman.org.uk>
References: <1476206815.989242.752665505.6525EE00@webmail.messagingengine.com>
 <a09a7ce1-8adf-e00c-7787-eb7ccc1a9e63@youngman.org.uk>
 <1476211037.1004490.752738017.68CF1E3E@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1476211037.1004490.752738017.68CF1E3E@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: moft@fmailbox.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 11/10/16 19:37, moft@fmailbox.com wrote:
>> feeling is that systemd is "to blame".
> I have no idea why that'd be the case.  That's the first time I've heard anybody suggest that.
>
That's why it's a "gut feel" :-)

But the impression I'm getting is that when mdadm runs in the foreground 
with root's permissions it runs fine. When it detects systemd and 
backgrounds into daemon mode, something goes wrong.

But I repeat - this is just a gut feel. I could be completely wrong :-)

Cheers,
Wol
