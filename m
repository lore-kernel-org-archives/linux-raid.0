From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 12:25:03 +0200
Message-ID: <CAJH6TXgp4CdrJ9a3Ku-R8Tj5Am+zeyRO_Bc_hFidWVLZW1f9vQ@mail.gmail.com>
References: <20170628131917.BF1911235B6@gemini.denx.de> <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <7688279.9aYLlOU3Xu@matkor-lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7688279.9aYLlOU3Xu@matkor-lenovo>
Sender: linux-raid-owner@vger.kernel.org
To: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-06-29 12:20 GMT+02:00 Mateusz Korniak <mateusz-lists@ant.gliwice.pl>:
> Also SMART long test should perform "read/verify scan of all of the user data
> area", so it is good idea to do it periodically and monitor results.

I'm already using this, but is not very reliable.
I had some disks failed by hw raid controller due to unreadable sector
(3/11) still passing the smart long test
and some failed smart long test still passing the hw raid check
