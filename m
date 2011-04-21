From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mismatch_cnt and Raid6
Date: Thu, 21 Apr 2011 14:38:38 +0100
Message-ID: <4DB0335E.1050306@anonymous.org.uk>
References: <4DB02A77.8000902@gmail.com> <20110421231419.1caa2f1c@notabene.brown> <4DB02F10.8020905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DB02F10.8020905@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Falgout <andrew.falgout@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/04/2011 14:20, Andrew Falgout wrote:
> It takes about 23 hours per check if I don't do anything to the array,
> so it will be a while before I can get back to you with results. But
> thanks for the quick response.

It may also be instructive to look at the full output of smartctl from 
all your drives - a short test may pass and the overall status be 
"PASSED" even on a very sick drive. You should also look in your system 
logs for ata errors to see which (if any) drive has given any read errors.

Cheers,

John.

