From: David Greaves <david@dgreaves.com>
Subject: Re: mdadm safe for all versions ?
Date: Wed, 17 Nov 2004 09:40:30 +0000
Message-ID: <419B1C8E.3030908@dgreaves.com>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E3EDC@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6F9171BE257CA742BFBCFA87B8F20F8D030E3EDC@NZURC900PEX1.ubsgs.ubsgroup.net>
Sender: linux-raid-owner@vger.kernel.org
To: peter.greis@ubs.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

peter.greis@ubs.com wrote:

>Morning All,
>
>Perhaps you all could clear this up for me... I have mdadm 1.5 installed (from an RPM) on SuSE 9.1 (now running kernel 2.6.8.1). Is it safe to back out 1.5 and install 1.8x from source, or does this require a kernel upgrade ?
>
Hi Peter

Neil's last mdadm announcment (about 1.8.1 on 5 Nov) said:

This is a "development" release of mdadm.  It should *not* be
considered stable and should be used primarily for testing.
The current "stable" version is 1.8.0.

And it won't need a kernel upgrade.

David


