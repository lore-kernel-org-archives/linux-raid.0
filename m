From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: Live Read Error Correction W/O Reconstruct?
Date: Fri, 27 Jan 2006 00:55:00 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0601270054280.30583@adsl.a2000.nu>
References: <20060124041452.68243.qmail@web35804.mail.mud.yahoo.com>
 <17365.43840.355844.214204@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17365.43840.355844.214204@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: mdw1103 <mdw1103@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 24 Jan 2006, Neil Brown wrote:

> On Monday January 23, mdw1103@yahoo.com wrote:
>> In 2004, Mr Brown wrote that read errors could be
>> handled without reconstruction. Has this been
>> implemented in 2.6.8? As I understand it,  this is the
>> way RAID is supposed to work.
>>
>
> Not in 2.6.8.
> It is implemented in 2.6.15 for raid5 and
> 2.6.16-rc1 for raid1 and raid6.

Neil,

is there anything logged in case this read error occurs ?
(which can be fixed)

