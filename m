From: Asdo <asdo@shiftmail.org>
Subject: Re: Raid5 device hangs in active state
Date: Mon, 12 Mar 2012 00:29:38 +0100
Message-ID: <4F5D3562.6060507@shiftmail.org>
References: <4F0A129E.5020706@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4F0A129E.5020706@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/08/12 23:03, Larkin Lowrey wrote:
> ...
> Interestingly, to me, when in this state, 'iostat -dx 1' shows the root
> ...

Do you have any  "avgqu-sz"  stuck at nonzero value in iostat -dx 1?


BTW this bug could be related to the recent post by Milan Broz, subject: 
"md raid5 fsync deadlock" .
Because also in your case fsyncs are not likely to complete... correct?
