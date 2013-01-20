From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Automatically adding spares on boot
Date: Sun, 20 Jan 2013 13:00:47 +0100
Message-ID: <50FBDC6F.80304@gmail.com>
References: <27071535.2.1358682702567.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27071535.2.1358682702567.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/20/2013 12:51 PM, Roy Sigurd Karlsbakk wrote:
>> Hope this clarifies. You don't need this script if your OS always
>> finds
>> your spares and adds them automatically to your arrays. Mine doesn't.
> 
> Really, if md 'forgets' a spare on reboot, that's a bug and should be reported.

http://www.google.com/#hl=en&q=mdadm+does+not+add+spares+on+boot

First hit.

root@zotac:~# lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 11.10
Release:	11.10
Codename:	oneiric
root@zotac:~# uname -a
Linux zotac 3.0.0-30-generic #47-Ubuntu SMP Wed Jan 2 23:16:29 UTC 2013
x86_64 x86_64 x86_64 GNU/Linux
root@zotac:~# mdadm -V
mdadm - v3.1.4 - 31st August 2010


